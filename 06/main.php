<?php
	# PART 1
	#
	function getOrbits(): array {
        $file = file("input.txt");

        foreach ($file as $line) {
            $line = explode(')', trim($line));
            $orbits[$line[1]] = $line[0];
        }

        return $orbits;
    }

    function countOrbits(): int {
    	global $orbits;
        $total = 0;

        foreach ($orbits as $satellite => $planet) {
            $total++; # count direct orbit
            while (isset($orbits[$planet])) {
                $total++; # count indirect orbit
                $planet = $orbits[$planet];
            }
        }

        return $total;
    }

    $orbits = getOrbits();
    $total = countOrbits();

    echo "Total number of direct and indirect orbits: $total\n";

    # PART 2
    #
    function getOrbitedBy(): array {
        $file = file("input.txt");

        foreach ($file as $line) {
            $line = explode(')', trim($line));
            $orbitedBy[$line[0]][] = $line[1];
        }

        return $orbitedBy;
    }

    function getNextPossiblePlanets(string $planet = null, array $visitedPlanets): array {
    	global $orbits, $orbitedBy;

    	$nextPossiblePlanets = [];
	    
	    if (isset($orbits[$planet]) && !in_array($orbits[$planet], $visitedPlanets)) {
	        array_push($nextPossiblePlanets, $orbits[$planet]);
	    }

	    if (is_array($orbitedBy[$planet])) {
		    foreach ($orbitedBy[$planet] as $index => $satellite) {
		        if (!in_array($satellite, $visitedPlanets)) {
		            array_push($nextPossiblePlanets, $satellite);
		        }
		    }
		}

	    return $nextPossiblePlanets;
    }

    function findShortestPath(string $from, string $to): int {
    	global $orbits, $orbitedBy;

    	$path = [ [$orbits[$from], 0] ];
    	$length = 0;
    	$visitedPlanets = [$from];

    	while (true) {
    		[$planet, $length] = array_shift($path);

    		$nextPossiblePlanets = getNextPossiblePlanets($planet, $visitedPlanets);

    		foreach ($nextPossiblePlanets as $nextPlanet) {
		        if ($nextPlanet === $orbits[$to]) {
		            $length++;
		            return $length;
		        }
		        array_push($path, [$nextPlanet, $length+1]);
		    }

		    array_push($visitedPlanets, $planet);
		}
    }

	$orbitedBy = getOrbitedBy();
    $transfers = findShortestPath("YOU", "SAN");

	echo "Minimum number of orbital transfers required: $transfers\n";
?>
