object Main {
  val allVars: List[Variable] = Color.values ++ Pet.values ++ Drink.values ++ Person.values ++ Cigarette.values // Create a list of all variables that are going to be used
  val within = (diff: Int) => (value: Int, value2: Int) => Math.abs(value - value2) == diff //Helper for doing within(2) => within 2 houses

  def main(args: Array[String]) {
    val csp = new CSP[Variable, Int]
    allVars.foreach { variable =>
      csp.addVar(variable, Set(1, 2, 3, 4, 5)) // Init all vars with all possible values
    }

    val same = (var1: Int, var2: Set[Int]) => var2.contains(var1)
    val notSame = (var1: Int, var2: Set[Int]) => var2.exists(_ != var1)
    val leftTo = (var1: Int, var2: Set[Int]) => var2.exists(var1 < _)
    val rightTo = (var1: Int, var2: Set[Int]) => var2.exists(var1 > _)
    val nextTo = (var1: Int, var2: Set[Int]) => var2.exists(within(1)(var1, _))

    csp.addConstraint(Milk, Milk, (var1, var2) => var1 == 3) // We know milk is in the third house
    csp.addConstraint(Norwegian, Norwegian, (var1, var2) => var1 == 1) // we know the norwegian lives in the first house

    // Other clues
    csp.addBiConstraint(Brit, Red, same)
    csp.addBiConstraint(Swede, Dog, same)
    csp.addBiConstraint(Dane, Tee, same)
    csp.addConstraint(Green, White, leftTo)
    csp.addConstraint(White, Green, rightTo)
    csp.addBiConstraint(Green, Coffee, same)
    csp.addBiConstraint(PallMall, Bird, same)
    csp.addBiConstraint(Yellow, Dunhill, same)
    csp.addBiConstraint(Winfield, Beer, same)
    csp.addBiConstraint(German, Rothmanns, same)
    csp.addBiConstraint(Malboro, Cat, nextTo)
    csp.addBiConstraint(Horse, Dunhill, nextTo)
    csp.addBiConstraint(Norwegian, Blue, nextTo)
    csp.addBiConstraint(Malboro, Water, nextTo)

    csp.addBiConstraint(Color.values, notSame)
    csp.addBiConstraint(Pet.values, notSame)
    csp.addBiConstraint(Drink.values, notSame)
    csp.addBiConstraint(Cigarette.values, notSame)
    csp.addBiConstraint(Person.values, notSame)

    println(csp.solve()) // GET ON WITH IT
    println(csp.solution)
  }
}

