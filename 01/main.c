#include <stdio.h>
#include <math.h>

int required_fuel(int mass) {
  int fuel = floor((double)mass / 3) - 2;

  if (fuel > 0)
    return fuel + required_fuel(fuel);

  return 0;
}

int main() {
  int mass;
  int total_fuel = 0;
  FILE *file;
  file = fopen("input.txt", "r");

  while (fscanf(file, "%d", &mass) != EOF)
    total_fuel += required_fuel(mass);

  fclose(file);

  printf("%d\n", total_fuel);

  return 0;
}
