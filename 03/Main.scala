import scala.io.Source
import scala.collection.mutable.ArrayBuffer

object Main {
  def readFile() : (Tuple2[String, String]) = {
    var lines = Source.fromFile("input.txt").getLines().toList
    return (lines(0), lines(1))
  }

  def getPointsFromWire(wire:String) : (ArrayBuffer[Tuple2[Int, Int]]) = {
    var x = 0
    var y = 0
    var points = ArrayBuffer((x, y))

    for (direction <- wire.split(",")) {
      var length = direction.substring(1).toInt

      direction.charAt(0) match {
        case 'U' => fillArrayUp(points, x, y, length); y += length
        case 'D' => fillArrayDown(points, x, y, length); y -= length
        case 'R' => fillArrayRight(points, x, y, length); x += length
        case 'L' => fillArrayLeft(points, x, y, length); x -= length
      }
    }

    points
  }

  def fillArrayUp(array:ArrayBuffer[Tuple2[Int, Int]], x:Int, y:Int, length:Int) : Unit = {
    for(i <- 1 to length) {
      array += Tuple2(x, y+i)
    }
  }

  def fillArrayDown(array:ArrayBuffer[Tuple2[Int, Int]], x:Int, y:Int, length:Int) : Unit = {
    for(i <- 1 to length) {
      array += Tuple2(x, y-i)
    }
  }

  def fillArrayRight(array:ArrayBuffer[Tuple2[Int, Int]], x:Int, y:Int, length:Int) : Unit = {
    for(i <- 1 to length) {
      array += Tuple2(x+i, y)
    }
  }

  def fillArrayLeft(array:ArrayBuffer[Tuple2[Int, Int]], x:Int, y:Int, length:Int) : Unit = {
    for(i <- 1 to length) {
      array += Tuple2(x-i, y)
    }
  }

  def shortestManhattanDistance(intersectionPoints:ArrayBuffer[Tuple2[Int, Int]]) : Int = {
    var distances = ArrayBuffer[Int]()

    for(point <- intersectionPoints) {
      distances += point._1.abs + point._2.abs
    }
    
    return distances.min
  }

  def lessSteps(intersectionPoints:ArrayBuffer[Tuple2[Int, Int]],
                pointsWire1:ArrayBuffer[Tuple2[Int, Int]],
                pointsWire2:ArrayBuffer[Tuple2[Int, Int]]) : Int = {
    var steps = ArrayBuffer[Int]()

    for(point <- intersectionPoints) {
      steps += pointsWire1.indexOf(point) + pointsWire2.indexOf(point)
    }

    return steps.min
  }

  def main(args: Array[String]): Unit = {
    val (wire1, wire2) = readFile
    val pointsWire1 = getPointsFromWire(wire1)
    val pointsWire2 = getPointsFromWire(wire2)
    val intersectionPoints = pointsWire1.intersect(pointsWire2) -= Tuple2(0, 0)

    // val distance = shortestManhattanDistance(intersectionPoints)
    // print("shortest Manhattan distance : ")
    // println(distance)

    val steps = lessSteps(intersectionPoints, pointsWire1, pointsWire2)
    print("closest intersection by steps : ")
    println(steps)
  }
}
