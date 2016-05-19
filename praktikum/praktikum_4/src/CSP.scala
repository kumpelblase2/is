class CSP[Var, Opt <% Comparable[Opt]]() {
  type Domain = Map[Var, Set[Opt]]
  type Constraint = (Opt, Set[Opt]) => Boolean
  var variables: List[Var] = List() // All variables that we have
  var domain: Domain = Map.empty // All possible values for the variables
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
  def revise(currentDomain: Domain, edge: (Var, Var, Constraint)) = {
    val (source, target, constraint) = edge
    val sourceValues = currentDomain(source)
    val targetValues = currentDomain(target)
    val newDomainValues = sourceValues.filter { value => // Filter out invalid values
      constraint(value, targetValues)
    }

    (newDomainValues.size != sourceValues.size, currentDomain + (source -> newDomainValues)) // Update domain with new values
  }

  private def ac3(initDomain: Domain): Domain = {
    var currentDomain = initDomain
    var q = constraints
    while(q.nonEmpty) {
      val current = q.head // Pop first element, could be any but this is the most general way
      q = q.tail
      revise(currentDomain, current) match {
        case (true, newDomain) => // If updates were made
          currentDomain = newDomain
          q = (q ++ constraints.filter { edge => // Get all constraints that don't have the same target node
            indexOfVariable(current._2) != indexOfVariable(edge._1)
          }).distinct
        case (false, _) => // Do nothing if nothing has changed
      }
    }

    currentDomain // Return updated domain
  }

  private def ac3LA(initDomain: Domain, cv: Int = 0) = {
    var currentDomain = initDomain
    var q = init(cv) // Create initial queue
    var consistent = true
    while (q.nonEmpty && consistent) { // Do it as long as we are consistent and have things to check
      val current = q.head  // Pop first element, could be any but this is the most general way
      q = q.tail
      revise(currentDomain, current) match { // Check for updates
        case (true, newDomain) => // if updates were made
          val (currentVariable, _, _) = current
          currentDomain = newDomain
          q = following(indexOfVariable(currentVariable), cv) // Get all the constraints that follow after this variable
          consistent = currentDomain(currentVariable).nonEmpty
        case _ => // Nothing to do if nothing was changed
      }
    }

    (consistent, currentDomain)
  }

  private def init(cv: Int) = {
    constraints.filter { edge => // Create the initial queue for the ac-3 LA
      indexOfVariable(edge._1) > cv && indexOfVariable(edge._2) == cv
    }
  }

  private def following(current: Int, cv: Int) = {
    constraints.filter { edge => // Get all variables that are after current index and don't have the current as target
      val (source, target, _) = edge
      indexOfVariable(target) != current && indexOfVariable(source) > cv
    }
  }

  private def solveRecursive(initDomain: Domain, cv: Int, allSolutions: Boolean = false): (Boolean, Seq[Domain]) = {
    val variable = variables(cv)
    val currDomain = initDomain(variable)
    if(currDomain.isEmpty) // If we don't have any possibilities, we're done and we don't have any solution
      return (false, List())

    ac3LA(initDomain + (variable -> Set(currDomain.head)), cv) match { // Check if the graph stays consistent with this
      case (true, newDomain) => // If it does
        if(cv == variables.size - 1) { // if we reached the last variable too, we're finished and it's solved
          if(allSolutions) { // if we should check the other possibilities
            val (_, successfulList) = solveRecursive(initDomain + (variable -> currDomain.tail), cv, allSolutions) // Get the other possibilities for the last variable
            return (true, List(newDomain) ++ successfulList)
          } else {
            return (true, List(newDomain)) // Just return the current domain as a solution since we are at the bottom
          }
        }

        solveRecursive(newDomain, cv + 1, allSolutions) match { // Check if also all next variables stay consistent
          case (true, recursiveDomain) => // if that's true, we have a solution so we can escalate back up
            if(allSolutions) { // if we should check all solutions, generate all solutions for the other variables before returning up
              val (_, successfulList) = solveRecursive(initDomain + (variable -> currDomain.tail), cv, allSolutions)
              (true, recursiveDomain ++ successfulList)
            } else { // if we only need one, just return the result we got
              (true, recursiveDomain)
            }
          case _ => // if the remaining domain cannot be made consistent, go back up
            solveRecursive(initDomain + (variable -> currDomain.tail), cv, allSolutions) // try again with another variable
        }
      case _ => // If it cannot be made consistent, we can remove the current one as a possibility
        solveRecursive(initDomain + (variable -> currDomain.tail), cv, allSolutions) // try again with another variable
    }
  }

  /**
    * Try to solve things.
    *
    * @param solveAll If all possible solutions should be returned
    * @return A tuple containing the success of finding a solution and all (or the first) solutions
    */
  def solve(solveAll: Boolean = false): (Boolean, Seq[Domain]) = {
    val consistentDomain = ac3(domain) // Run once to make sure everything is consistent and all constraints are met
    solveRecursive(consistentDomain, 0, solveAll) // Start recursion with trying out values
  }

  /**
    * Returns the index of the variable in the graph
    *
    * @param variable The variable to get the index for
    * @return         The index
    */
  private def indexOfVariable(variable: Var) = {
    variables.indexOf(variable)
  }

  /**
    * Gets the solution as a String
    *
    * @return Solution string
    */
  def domainString: String = {
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

  class ConstraintMaker[T](val csp: CSP[Var, T], val var1: Var)(implicit ev: T => Comparable[T]) { // Need the implicit to make sure that T can be compared
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

  class CollectionConstraintMaker[T](val csp: CSP[Var, T], val var1: Traversable[Var]) {
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