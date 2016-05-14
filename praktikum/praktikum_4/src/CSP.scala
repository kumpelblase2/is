class CSP[Var, Opt] {
  type Constraint = (Opt, Set[Opt]) => Boolean
  var variables: List[Var] = List()
  var domain: Map[Var, Set[Opt]] = Map.empty
  var constraints: List[(Var, Var, Constraint)] = List()

  def addVar(variable: Var, values: Set[Opt]): Unit = {
    variables = variable +: variables
    domain = domain.updated(variable, values)
  }

  def addBiConstraint(variable: Var, variable2: Var, constraint: Constraint): Unit = {
    constraints = constraints ++ List((variable, variable2, constraint), (variable2, variable, constraint))
  }

  def addConstraint(variable: Var, variable2: Var, constraint: Constraint): Unit = {
    constraints = constraints ++ List((variable, variable2, constraint))
  }

  def addBiConstraint(variables: List[Var], constraint: Constraint): Unit = {
    variables.foreach { variable1 =>
      variables.foreach { variable2 =>
        if(variable1 != variable2) {
          this.addConstraint(variable1, variable2, constraint)
        }
      }
    }
  }

  def revise(edge: (Var, Var, Constraint)) = {
    val (source, target, constraint) = edge
    val sourceValues = domain(source)
    val targetValues = domain(target)
    val newDomainValues = sourceValues.filter { value =>
      constraint(value, targetValues)
    }

    domain = domain.updated(source, newDomainValues)
    newDomainValues.size != sourceValues.size
  }

  private def ac3(): Unit = {
    var q = constraints.filter(_ => true)
    while(q.nonEmpty) {
      val current = q.head
      q = q.tail
      if(revise(current)) {
        q = constraints.filter { edge =>
          indexOfVariable(current._2) != indexOfVariable(edge._1)
        }
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
        q = following(indexOfVariable(current._1), cv)
        val k = current._1
        consistent = domain(k).nonEmpty
      }
    }

    consistent
  }

  private def init(cv: Int) = {
    constraints.filter { edge =>
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
    if(currDomain.isEmpty)
      return false

    val oldDomain = domain
    domain = domain.updated(variable, Set(currDomain.head))
    if(ac3LA(cv)) {
      if(cv == variables.size - 1)
        return true

      if(solveRecursive(cv + 1))
        return true
    }

    domain = oldDomain
    domain = domain.updated(variable, currDomain.tail)
    solveRecursive(cv)
  }

  def solve(): Boolean = {
    ac3()
    solveRecursive(0)
  }

  private def indexOfVariable(variable: Var) = {
    variables.indexOf(variable)
  }

  def solution: String = {
    domain.map { entry =>
      val (variable, value) = entry
      s"$variable = ${value.head}"
    }.reduce(_ + "\n" + _)
  }
}