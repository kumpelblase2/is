sealed trait Variable {
  val index: Int
}

trait VariableCollection[T] {
  def values : List[T]
}

abstract class Person(val index: Int) extends Variable
object German extends Person(1)
object Swede extends Person(2)
object Brit extends Person(3)
object Dane extends Person(4)
object Norwegian extends Person(5)

object Person extends VariableCollection[Person] {
  val values = List(German, Swede, Brit, Dane, Norwegian)
}

abstract class Color(val index: Int) extends Variable
object Red extends Color(6)
object Blue extends Color(7)
object Green extends Color(8)
object White extends Color(9)
object Yellow extends Color(10)

object Color extends VariableCollection[Color] {
  val values = List(Red, Blue, Green, White, Yellow)
}

abstract class Drink(val index: Int) extends Variable
object Water extends Drink(11)
object Tee extends Drink(12)
object Coffee extends Drink(13)
object Milk extends Drink(14)
object Beer extends Drink(15)

object Drink extends VariableCollection[Drink] {
  val values = List(Water, Tee, Coffee, Milk, Beer)
}

abstract class Cigarette(val index: Int) extends Variable
object Dunhill extends Cigarette(16)
object PallMall extends Cigarette(17)
object Winfield extends Cigarette(18)
object Rothmanns extends Cigarette(19)
object Malboro extends Cigarette(20)

object Cigarette extends VariableCollection[Cigarette] {
  val values = List(Dunhill, PallMall, Winfield, Rothmanns, Malboro)
}

abstract class Pet(val index: Int) extends Variable
object Dog extends Pet(21)
object Bird extends Pet(22)
object Horse extends Pet(23)
object Cat extends Pet(24)
object Fish extends Pet(25)

object Pet extends VariableCollection[Pet] {
  val values = List(Dog, Bird, Horse, Cat, Fish)
}