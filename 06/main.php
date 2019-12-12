<?php
	function getOrbits(): array {
        $file = file("input.txt");
        $orbits = [];

        foreach($file as $line) {
            $line = explode(')', trim($line));
            $orbits[$line[1]] = $line[0];
        }

        return $orbits;
    }

    function countOrbits(array $orbits): int {
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
    $total = countOrbits($orbits);

    echo "Total number of direct and indirect orbits: $total\n";
?>
