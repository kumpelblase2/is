class CSP[Var, Opt <% Comparable[Opt]]() {
  type Constraint = (Opt, Set[Opt]) => Boolean
  var variables: List[Var] = List() // All variables that we have
  var domain: Map[Var, Set[Opt]] = Map.empty // All possible values for the variables
  var constraints: List[(Var, Var, Constraint)] = List() // All constraints / edges

  /**
    * Adds a variables to the graph and set the possibles values
    *
    * @param variable Variable
    * @param values   Possible values
    */
  def addVar(variable: Var, values: Set[Opt]): Unit = {
    variables = variable +: variables
    domain = domain.updated(variable, values)
  }

  /**
    * Add a Bi-Directional constraint. This is equal to calling #{addConstraint} twice with different order of variables.
    *
    * @param variable   Source variable
    * @param variable2  Target variable
    * @param constraint Constraint
    */
  def addBiConstraint(variable: Var, variable2: Var, constraint: Constraint): Unit = {
    constraints = constraints ++ List((variable, variable2, constraint), (variable2, variable, constraint))
  }

  /**
    * Adds a constraint to the graph.
    *
    * @param variable   Source variable
    * @param variable2  Target variable
    * @param constraint Constraint
    */
  def addConstraint(variable: Var, variable2: Var, constraint: Constraint): Unit = {
    constraints = constraints ++ List((variable, variable2, constraint))
  }

  /**
    * Adds a Bi-Directional constraint between every variable in the sequence.
    *
    * @param variables  All variables
    * @param constraint Constraint
    */
  def addBiConstraint(variables: Traversable[Var], constraint: Constraint): Unit = {
    variables.foreach { variable1 =>
      variables.foreach { variable2 =>
        if(variable1 != variable2) { // Only add it if the variables are not the same
          this.addConstraint(variable1, variable2, constraint)
        }
      }
    }
  }

  /**
    * Revises the given edge and updates the domain if any changes are necessary
    *
    * @param edge The edge to check
    * @return     true of false depending if updates were made
    */
  def revise(edge: (Var, Var, Constraint)) = {
    val (source, target, constraint) = edge
    val sourceValues = domain(source)
    val targetValues = domain(target)
    val newDomainValues = sourceValues.filter { value => // Filter out invalid values
      constraint(value, targetValues)
    }

    domain = domain.updated(source, newDomainValues) // Update domain with new values
    newDomainValues.size != sourceValues.size
  }

  private def ac3(): Unit = {
    var q = constraints.filter(_ => true) // Just create a copy
    while(q.nonEmpty) {
      val current = q.head
      q = q.tail
      if(revise(current)) {
        q = (q ++ constraints.filter { edge => // Get all constraints that don't have the same target node
          indexOfVariable(current._2) != indexOfVariable(edge._1)
        }).distinct
      }
    }
  }

  private def ac3LA(cv: Int = 0) = {
    var q = init(cv)
    var consistent = true
    while (q.nonEmpty && consistent) {
      val current = q.head
      q = q.tail
      if (revise(current)) {
        q = following(indexOfVariable(current._1), cv) // Get all the constraints that follow after this variable
        val k = current._1
        consistent = domain(k).nonEmpty
      }
    }

    consistent
  }

  private def init(cv: Int) = {
    constraints.filter { edge => // Create the initial queue for the ac-3 LA
      indexOfVariable(edge._1) > cv && indexOfVariable(edge._2) == cv
    }
  }

  private def following(current: Int, cv: Int) = {
    constraints.filter { edge =>
      val (source, target, _) = edge
      indexOfVariable(target) != current && indexOfVariable(source) > cv
    }
  }

  private def solveRecursive(cv: Int): Boolean = {
    val variable = variables(cv)
    val currDomain = domain(variable)
    if(currDomain.isEmpty) // If we don't have any possibilities, we're done
      return false

    val oldDomain = domain
    domain = domain.updated(variable, Set(currDomain.head)) // Just try one value
    if(ac3LA(cv)) { // Check if the graph stays consistent with this
      if(cv == variables.size - 1) // if we reached the last variable too, we're finished and it's solved
        return true

      if(solveRecursive(cv + 1)) // Recursive call for next variable
        return true
    }

    domain = oldDomain // Restore old domain
    domain = domain.updated(variable, currDomain.tail) // Since the chose value didn't work, remove it
    solveRecursive(cv) // try again with another variable
  }

  /**
    * Try to solve things.
    *
    * @return true or false depending if it succeeded or not
    */
  def solve(): Boolean = {
    ac3() // Run once to make sure everything is consistent and all constraints are met
    solveRecursive(0) // Start recursion with trying out values
  }

  private def indexOfVariable(variable: Var) = {
    variables.indexOf(variable)
  }

  /**
    * Gets the solution as a String
    *
    * @return Solution string
    */
  def solution: String = {
    domain.map { entry =>
      val (variable, value) = entry
      s"$variable = ${value.head}"
    }.reduce(_ + "\n" + _)
  }

  implicit def toConstraintMaker(variable1: Var) : ConstraintMaker[Opt] = {
    new ConstraintMaker[Opt](this, variable1)
  }

  implicit def toCollectionConstraintMaker(variable1: Traversable[Var]) : CollectionConstraintMaker[Opt] = {
    new CollectionConstraintMaker[Opt](this, variable1)
  }

  class ConstraintMaker[T](val csp: CSP[Var, T], val var1: Var)(implicit ev$1: T => Comparable[T]) {
    val same = (var1: T, var2: Set[T]) => var2.contains(var1)
    val notSame = (var1: T, var2: Set[T]) => var2.exists(_ != var1)
    val leftTo = (var1: T, var2: Set[T]) => var2.exists(var1.compareTo(_) < 0)
    val rightTo = (var1: T, var2: Set[T]) => var2.exists(var1.compareTo(_) > 0)

    def sameAs(var2: Var): Unit = {
      csp.addBiConstraint(var1, var2, same)
    }

    def notSameAs(var2: Var): Unit = {
      csp.addBiConstraint(var1, var2, notSame)
    }

    def leftTo(var2: Var): Unit = {
      csp.addConstraint(var1, var2, leftTo)
      csp.addConstraint(var2, var1, rightTo)
    }

    def rightTo(var2: Var): Unit = {
      csp.addConstraint(var1, var2, rightTo)
      csp.addConstraint(var2, var1, leftTo)
    }

    def equalTo(value: T): Unit = {
      csp.addConstraint(var1, var1, (var1, var2) => var1 == value)
    }
  }

  class CollectionConstraintMaker[T](val csp: CSP[Var, T], val var1: Traversable[Var])(implicit ev$1: T => Comparable[T]) {
    val same = (var1: T, var2: Set[T]) => var2.contains(var1)
    val notSame = (var1: T, var2: Set[T]) => var2.exists(_ != var1)

    def allSame(): Unit = {
      csp.addBiConstraint(var1, same)
    }

    def allDifferent(): Unit = {
      csp.addBiConstraint(var1, notSame)
    }
  }
}