/*
Deutschen
Scheden
Brieten
Dänen
Norweger
 */

/*
Rotes Haus
Grünes Haus
Gelbes Haus
Weißes Haus
Blaues Haus
 */

/*
Hunde
Vogel
Pferd
Karze
Fisch <- Gesucht
 */

/*
Tee
Kaffee
Milch
Bier
Wasser
 */
/*
Dunhill
Pallmall
Rothmanns
Malboro
Winfield
*/

sealed trait Person
object German extends Person
object Swede extends Person
object Brit extends Person
object Dane extends Person
object Norwegian extends Person

case class Variable(possibilities: Set[Person])

sealed trait Contraint {
  def isConsistent() : Boolean
  def isReverseConsistent(): Boolean
}

case class Arc(variable1: Variable, variable2: Variable, constraint: Contraint)

val network : List[Variable] = List()