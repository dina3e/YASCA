<?php

// MI variables

$z1[1];
$z1[2];

$z1[$i];    // MI: $z1[1], z1[2]

$z2[1][1];
$z2[1][2];
$z2[2][1];
$z2[2][2];

$z2[1][$i];  // MI: $z2[1][1], $z2[1][2]
$z2[$i][1];  // MI: $z2[1][1], $z2[2][1]
$z2[$i][$j]; // MI: $z2[1][1], $z2[1][2], $z2[2][1], $z2[2][2]

$z3[1][2][3][4];
$z3[1][9][3][9];

$z3[1][$i][3][$j];  // MI: $z3[1][2][3][4], $z3[1][9][3][9]

~_hotspot0;


?>