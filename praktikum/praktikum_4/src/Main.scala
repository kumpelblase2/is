object Main {
  val allVars: List[Variable] = Color.values ++ Pet.values ++ Drink.values ++ Person.values ++ Cigarette.values // Create a list of all variables that are going to be used
  val within = (diff: Int) => (value: Int, value2: Int) => Math.abs(value - value2) == diff //Helper for doing within(2) => within 2 houses

  def main(args: Array[String]) {
    val csp = new CSP[Variable, Int]
    import csp._ // Import things to make implicits work

    allVars.foreach { variable =>
      csp.addVar(variable, Set(1, 2, 3, 4, 5)) // Init all vars with all possible values
    }

    val nextTo = (var1: Int, var2: Set[Int]) => var2.exists(within(1)(var1, _))

    Milk equalTo 3 // We know milk is in the third house
    Norwegian equalTo 1 // we know the norwegian lives in the first house
    // Other clues
    Brit sameAs Red
    Swede sameAs Dog
    Dane sameAs Tee
    Green leftTo White
    Green sameAs Coffee
    PallMall sameAs Bird
    Yellow sameAs Dunhill
    Winfield sameAs Beer
    German sameAs Rothmanns
    // Can't really do these with the nice syntax
    csp.addBiConstraint(Malboro, Cat, nextTo)
    csp.addBiConstraint(Horse, Dunhill, nextTo)
    csp.addBiConstraint(Norwegian, Blue, nextTo)
    csp.addBiConstraint(Malboro, Water, nextTo)

    Color.values allDifferent()
    Pet.values allDifferent()
    Drink.values allDifferent()
    Cigarette.values allDifferent()
    Person.values allDifferent()

    val (_, solutions) = csp.solve(true) // GET ON WITH IT
    solutions.map(createTable)
      .map(Tabulator.format)
      .foreach { table =>
        println(table)
        println()
      }
  }

  def createTable(domain: Map[Variable, Set[Int]]): List[List[String]] = { // Create tables for solution
    var table : List[List[String]] = List(List("Houses", "House 1", "House 2", "House 3", "House 4", "House 5"))
    List(Person, Color, Pet, Drink, Cigarette).foreach { kind =>
      val values = kind.values
      var row: List[String] = List(kind.name)
      for(index <- 1 to 5) {
        val entry = domain.filter { case (key, value) => values.contains(key) }.find { case (key, value) => value.contains(index) }
        entry.map { case (key, _) => key }.foreach { variable =>
          row = row :+ variable.name
        }
      }

      table = table :+ row
    }
    table
  }
}

object Tabulator { // Helper object to make formatting easier
  def format(table: Seq[Seq[Any]]) = table match {
    case Seq() => ""
    case _ =>
      val sizes = for (row <- table) yield (for (cell <- row) yield if (cell == null) 0 else cell.toString.length)
      val colSizes = for (col <- sizes.transpose) yield col.max
      val rows = for (row <- table) yield formatRow(row, colSizes)
      formatRows(rowSeparator(colSizes), rows)
  }

  def formatRows(rowSeparator: String, rows: Seq[String]): String = (
    rowSeparator ::
      rows.head ::
      rowSeparator ::
      rows.tail.toList :::
      rowSeparator ::
      List()).mkString("\n")

  def formatRow(row: Seq[Any], colSizes: Seq[Int]) = {
    val cells = (for ((item, size) <- row.zip(colSizes)) yield if (size == 0) "" else ("%" + size + "s").format(item))
    cells.mkString("|", "|", "|")
  }

  def rowSeparator(colSizes: Seq[Int]) = colSizes map { "-" * _ } mkString("+", "+", "+")
}