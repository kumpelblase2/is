sealed trait Variable {
  def name : String = {
    toString.split("\\$")(0)
  }
}

trait VariableCollection[T] {
  def values : List[T]
  def name : String = {
    toString.split("\\$")(0)
  }
}

abstract class Person extends Variable
object German extends Person
object Swede extends Person
object Brit extends Person
object Dane extends Person
object Norwegian extends Person

object Person extends VariableCollection[Person] {
  val values = List(German, Swede, Brit, Dane, Norwegian)
}

abstract class Color extends Variable
object Red extends Color
object Blue extends Color
object Green extends Color
object White extends Color
object Yellow extends Color

object Color extends VariableCollection[Color] {
  val values = List(Red, Blue, Green, White, Yellow)
}

abstract class Drink extends Variable
object Water extends Drink
object Tee extends Drink
object Coffee extends Drink
object Milk extends Drink
object Beer extends Drink

object Drink extends VariableCollection[Drink] {
  val values = List(Water, Tee, Coffee, Milk, Beer)
}

abstract class Cigarette extends Variable
object Dunhill extends Cigarette
object PallMall extends Cigarette
object Winfield extends Cigarette
object Rothmanns extends Cigarette
object Malboro extends Cigarette

object Cigarette extends VariableCollection[Cigarette] {
  val values = List(Dunhill, PallMall, Winfield, Rothmanns, Malboro)
}

abstract class Pet extends Variable
object Dog extends Pet
object Bird extends Pet
object Horse extends Pet
object Cat extends Pet
object Fish extends Pet

object Pet extends VariableCollection[Pet] {
  val values = List(Dog, Bird, Horse, Cat, Fish)
}