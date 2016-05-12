val allVars: List[Variable] = Color.values ++ Pet.values ++ Drink.values ++ Person.values ++ Cigarette.values

var domain : Map[Variable, Set[Int]] = allVars.map(variable => variable -> Set(1, 2, 3, 4, 5)).toMap.updated(Norwegian, Set(1)).updated(Milk, Set(3))

case class ValuePar(first: Set[Int], second: Set[Int])

abstract class Constraint(variable: Variable, variable2: Variable) {
  def revise() : Boolean = {
    val valuePar = ValuePar(domain(variable), domain(variable2))
    val newFirst = update(valuePar.first, valuePar.second)
    val oldLength = valuePar.first.size
    domain = domain.updated(variable, newFirst)
    newFirst.size != oldLength
  }

  def update(first: Set[Int], second: Set[Int]) : Set[Int]
}

class SameConstraint(variable: Variable, variable2: Variable) extends Constraint(variable, variable2) {
  override def update(first: Set[Int], second: Set[Int]): Set[Int] = {
    first.intersect(second)
  }
}

class NotSameConstraint(variable: Variable, variable2: Variable) extends Constraint(variable, variable2) {
  override def update(first: Set[Int], second: Set[Int]): Set[Int] = {
    first.diff(second)
  }
}

class LeftToConstraint(variable: Variable, variable2: Variable) extends Constraint(variable, variable2) {
  override def update(first: Set[Int], second: Set[Int]): Set[Int] = {
    first.filter(value => second.exists(second => value < second ))
  }
}

class NextToConstraint(variable: Variable, variable2: Variable) extends Constraint(variable, variable2) {
  override def update(first: Set[Int], second: Set[Int]): Set[Int] = {
    first.filter(value => second.exists(second => Math.abs(second - value) == 1 ))
  }
}

class ConstraintVariable(variable: Variable) {
  def same(variable2: Variable) = {
    new SameConstraint(variable, variable2)
  }

  def leftTo(variable2: Variable) = {
    new LeftToConstraint(variable, variable2)
  }

  def nextTo(variable2: Variable) = {
    new NextToConstraint(variable, variable2)
  }

  def notSame(variable2: Variable) = {
    new NotSameConstraint(variable, variable2)
  }
}

implicit def toConstraintVariable(variable: Variable) : ConstraintVariable = {
  new ConstraintVariable(variable)
}

val first = Brit same Red
val second = Swede same Dog
val third = Dane same Tee
val fourth = Green leftTo White
val fifth = Green same Coffee
val sixth = PallMall same Bird
val eigth = Yellow same Dunhill
val tenth = Malboro nextTo Cat
val eleventh = Horse nextTo Dunhill
val twelthe = Winfield same Beer
val thirteenth = Norwegian nextTo Blue
val fourteenth = German same Malboro
val fifteenth = Malboro nextTo Water

var constrains : List[Constraint] = List(first, second, third, fourth, fifth, sixth, eigth, tenth, eleventh, twelthe, thirteenth, fourteenth, fifteenth)

var neightbours: Map[Variable, Set[Variable]] = allVars.map(variable => variable -> Set[Variable]()).toMap

def appendNeighbor(key: Variable, value: Variable) {
  neightbours = neightbours.updated(key, neightbours.getOrElse(key, Set()) + value)
}

appendNeighbor(Brit, Red)
appendNeighbor(Swede, Dog)
appendNeighbor(Dane, Tee)
appendNeighbor(Green, White)
appendNeighbor(Green, Coffee)
appendNeighbor(PallMall, Bird)
appendNeighbor(Yellow, Dunhill)
appendNeighbor(Malboro, Cat)
appendNeighbor(Horse, Dunhill)
appendNeighbor(Winfield, Beer)
appendNeighbor(Norwegian, Blue)
appendNeighbor(German, Malboro)
appendNeighbor(Malboro, Water)

val types = List(Color, Pet, Drink, Person, Cigarette)

types.foreach { t =>
  t.values.foreach { A =>
    t.values.foreach { B =>
      if(A != B) {
        appendNeighbor(A, B)
        appendNeighbor(B, A)
        constrains = constrains.+:(A notSame B)
        constrains = constrains.+:(B notSame A)
      }
    }
  }
}

def solve(variables : List[Variable], domain: Map[Variable, Seq[Int]], neightbors : Map[Variable, Set[Variable]], constraints : List[Constraint]) = {
  var q = constraints
  var consistent = true
  while(q.nonEmpty && consistent) {
    val current = q.head
    if(current.revise()) {
      // TODO
    }
  }
}