$gBoT = 3;                     // box outside - thickness
$gBoG = 1;                     // box outside - gap
$gBoW = 57+2*($gBoT+$gBoG);    // box outside - wide
$gBoH = 44+2*($gBoT+$gBoG);    // box outside - height
$gBoL = 78+1*($gBoT+$gBoG);    // box outside - length
$gBoJW = 3;                    // box outside - joins wide
$gBoJH = 2;                    // box outside - joins height
$gBoJL = 4;                    // box outside - joins length

$gBiT = 3;                     // box inside - thickness
$gBiW = $gBoW-2*($gBoT+$gBoG); // box inside - wide
$gBiH = $gBoH-2*($gBoT+$gBoG); // box inside - height
$gBiL = $gBoL-1*($gBoT+$gBoG); // box inside - length
$gBiJW = 2;                    // box inside - joins wide
$gBiJH = 2;                    // box inside - joins height
$gBiJL = 4;                    // box inside - joins length

echo("Box Outside ",$gBoW," x ",$gBoH," x ",$gBoL);
echo("Box Inside  ",$gBiW," x ",$gBiH," x ",$gBiL);
echo("Box Storage ",$gBiW-2*$gBiT," x ",$gBiH-2*$gBiT," x ",$gBiL-2*$gBiT);
if ($gBoW > $gBoH) { 
 $gDimOX = 3*$gBoH + 2;
 $gDimOY = 2*$gBoL + 1;
 echo("Area Outside ",$gDimOX," x ",$gDimOY);
} else {
 $gDimOX = 2*$gBoH + 2 + $gBoW;
 $gDimOY = 2*$gBoL + 1;
 echo("Area Outside ",$gDimOX," x ",$gDimOY);
}
$gDimIX = $gBiH+1+$gBiH+1+$gBiW;
$gDimIY = $gBiH+1+$gBiL;
echo("Area Inside ",$gDimIX," x ",$gDimIY);

mBoxInside();
// mBoxOutside();

module mBoxInside() {
 if ($preview) {
  union() {
   $gCut = 0.0;   // laser cut
   $gExp = 5.0;   // explore joins
   // side down
   translate([0,0,-$gExp])
    mLaserCutPlate($gBiW,$gBiL,$gBiT, -$gBiJW,-$gBiJL,-$gBiJW,-$gBiJL, $gCut);
   // side right
   translate([$gExp,0,0])
    translate([$gBiW,0,0])
     rotate([0,-90,0])
     mLaserCutPlate($gBiH,$gBiL,$gBiT, -$gBiJH,-0.5,$gBiJH,$gBiJL, $gCut);
   // side left
   translate([-$gExp,0,0])
    translate([0,0,$gBiH])
     rotate([0,90,0])
     mLaserCutPlate($gBiH,$gBiL,$gBiT, $gBiJH,$gBiJL,-$gBiJH,-0.5, $gCut);
   // side front
   translate([0,-$gExp,0])
    translate([0,0,$gBiH])
     rotate([-90,0,0])
     mLaserCutPlate($gBiW,$gBiH,$gBiT, -0.5,$gBiJH,$gBiJW,-$gBiJH, $gCut);
   // side back
   translate([0,$gExp,0])
    translate([0,$gBiL,0])
     rotate([90,0,0])
     mLaserCutPlate($gBiW,$gBiH,$gBiT, $gBiJW,-$gBiJH,-0.5,$gBiJH, $gCut);
  } 
 } else {
  projection()
  union() {
   $gCut = 0.2;   // laser cut
   // side front
   mLaserCutPlate($gBiW,$gBiH,$gBiT, -0.5,$gBiJH,$gBiJW,-$gBiJH, $gCut);
   // side back
   translate([$gBiW+1,0,0])
    mLaserCutPlate($gBiW,$gBiH,$gBiT, $gBiJW,-$gBiJH,-0.5,$gBiJH, $gCut);
   // side right
   translate([0,$gBiH+1,0])
   mLaserCutPlate($gBiH,$gBiL,$gBiT, -$gBiJH,-0.5,$gBiJH,$gBiJL, $gCut);
   // side left
   translate([$gBiH+1,$gBiH+1,0])
     mLaserCutPlate($gBiH,$gBiL,$gBiT, $gBiJH,$gBiJL,-$gBiJH,-0.5, $gCut);
   // side down
   translate([$gBiH+1+$gBiH+1,$gBiH+1,0])
   mLaserCutPlate($gBiW,$gBiL,$gBiT, -$gBiJW,-$gBiJL,-$gBiJW,-$gBiJL, $gCut);
  }
 }
}

module mBoxOutside() {
 if ($preview) {
  translate([-40,0,0])
  translate([-$gBoW-$gBoG,0,0])
  // color("brown",alpha=0.1)
  translate([-$gBoT-$gBoG,0,-$gBoT-$gBoG])
  union() {
   $gCut = 0.0;   // laser cut
   $gExp = 3.0;   // explore joins
   // side down
   translate([0,0,-$gExp])
    mLaserCutPlate($gBoW,$gBoL,$gBoT, -0.5,$gBoJL,$gBoJW,-$gBoJL, $gCut);
   // side right
   translate([$gExp,0,0])
    translate([$gBoW,0,0])
     rotate([0,-90,0])
     mLaserCutPlate($gBoH,$gBoL,$gBoT, -0.5,$gBoJL,$gBoJH,-$gBoJL, $gCut);
   // side top
   translate([0,0,$gExp])
    translate([$gBoW,0,$gBoH])
     rotate([0,-180,0])
     mLaserCutPlate($gBoW,$gBoL,$gBoT, -0.5,$gBoJL,$gBoJW,-$gBoJL, $gCut);
   // side left
   translate([-$gExp,0,0])
    translate([0,0,$gBoH])
     rotate([0,90,0])
     mLaserCutPlate($gBoH,$gBoL,$gBoT, -0.5,$gBoJL,$gBoJH,-$gBoJL, $gCut);
   // side back
   translate([0,$gExp,0])
    translate([0,$gBoL,0])
     rotate([90,0,0])
     mLaserCutPlate($gBoW,$gBoH,$gBoT, -$gBoJW,-$gBoJH,-$gBoJW,-$gBoJH, $gCut);
  } 
 } else {
  translate([-175,0,0])
  projection()
  union() {
   $gCut = 0.2;   // laser cut
   // side down
   mLaserCutPlate($gBoW,$gBoL,$gBoT, -0.5,$gBoJL,$gBoJW,-$gBoJL, $gCut);
   // side top
   translate([$gBoW+1,0,0])
    mLaserCutPlate($gBoW,$gBoL,$gBoT, -0.5,$gBoJL,$gBoJW,-$gBoJL, $gCut);
   // side right
   translate([0,$gBoL+1,0])
    mLaserCutPlate($gBoH,$gBoL,$gBoT, -0.5,$gBoJL,$gBoJH,-$gBoJL, $gCut);
   // side left
   translate([$gBoH+1,$gBoL+1,0])
    mLaserCutPlate($gBoH,$gBoL,$gBoT, -0.5,$gBoJL,$gBoJH,-$gBoJL, $gCut);
   // side back
   if ($gBoH > $gBoW) {
    translate([2*($gBoH+1),$gBoL+1,0])
     mLaserCutPlate($gBoW,$gBoH,$gBoT, -$gBoJW,-$gBoJH,-$gBoJW,-$gBoJH, $gCut);
   } else {
     translate([2*($gBoH+1),$gBoL+1,0])
     translate([$gBoH,0,0])
     rotate([0,0,90])
     mLaserCutPlate($gBoW,$gBoH,$gBoT, -$gBoJW,-$gBoJH,-$gBoJW,-$gBoJH, $gCut);
   }
  }
 }
}

// Util 

module mLaserCutPlate(
  $pLcpW     // wide
 ,$pLcpH     // height
 ,$pLcpT     // thickness
 ,$pLcpF1    // finger-1
 ,$pLcpF2    // finger-2
 ,$pLcpF3    // finger-3
 ,$pLcpF4    // finger-4
 ,$pLcpC=0.2 // cut gap (default 0.2mm)
 ) {
 // plate without border or join
 $mLcpW = $pLcpW-2*$pLcpT+$pLcpC;
 $mLcpH = $pLcpH-2*$pLcpT+$pLcpC;
 $mLcpX = (2*$pLcpT-$pLcpC)/2;
 $mLcpY = (2*$pLcpT-$pLcpC)/2;
 color("blue")
 translate([$mLcpX,$mLcpY,0])
  cube([$mLcpW,$mLcpH,$pLcpT]);
 // border or join
 mLaserCutPlateJoin($pLcpW,$pLcpT,$pLcpF1,$pLcpC);
 translate([$pLcpW,$pLcpH,0])
  rotate([0,0,180])
  mLaserCutPlateJoin($pLcpW,$pLcpT,$pLcpF3,$pLcpC);
 translate([$pLcpW,0,0])
  rotate([0,0,90])
  mLaserCutPlateJoin($pLcpH,$pLcpT,$pLcpF2,$pLcpC);   
 translate([0,$pLcpH,0])
  rotate([0,0,-90])
  mLaserCutPlateJoin($pLcpH,$pLcpT,$pLcpF4,$pLcpC);   
}

module mLaserCutPlateJoin(
  $pLcpjW    // wide
 ,$pLcpjT    // thickness/height
 ,$pLcpjF    // fingers
 ,$pLcpjC    // cut gap
 ) {
 if ($pLcpjF == 0.5) {
  $mLcpjFW = $pLcpjW-$pLcpjT+$pLcpjC;
  $mLcpjFX = -$pLcpjC/2;
  $mLcpjFY = -$pLcpjC/2;
  color("yellow")
  translate([$mLcpjFX,$mLcpjFY,0])
   cube([$mLcpjFW,$pLcpjT,$pLcpjT]);   
 }
 else if ($pLcpjF == -0.5) {
  $mLcpjFW = $pLcpjW-2*$pLcpjT+$pLcpjC;
  $mLcpjFX = -$pLcpjC/2+$pLcpjT;
  $mLcpjFY = -$pLcpjC/2;
  color("gray")
  translate([$mLcpjFX,$mLcpjFY,0])
   cube([$mLcpjFW,$pLcpjT,$pLcpjT]);   
 }
 else if ($pLcpjF > 0) {
  $mLcpjFW = ($pLcpjW-$pLcpjT+$pLcpjC*$pLcpjF)/(2*$pLcpjF);
  $mLcpjFS = ($pLcpjW-$pLcpjT)/$pLcpjF;
  $mLcpjFX = -$pLcpjC/2;
  $mLcpjFY = -$pLcpjC/2;
  color("red")
  for ($mLcpjFN=[1:$pLcpjF]) {
   translate([$mLcpjFX+$mLcpjFS*($mLcpjFN-1),$mLcpjFY,0])
    cube([$mLcpjFW,$pLcpjT,$pLcpjT]);   
  }
 }
 else if ($pLcpjF < 0) {
  $mLcpjFW = ($pLcpjW-$pLcpjT+$pLcpjC*-$pLcpjF)/(2*-$pLcpjF);
  $mLcpjFS = ($pLcpjW-$pLcpjT)/-$pLcpjF;
  $mLcpjFX = -$pLcpjC/2+$pLcpjT;
  $mLcpjFY = -$pLcpjC/2;
  color("green")
  for ($mLcpjFN=[1:-$pLcpjF]) {
   translate([$mLcpjFX+$mLcpjFS*($mLcpjFN-1),$mLcpjFY,0])
    cube([$mLcpjFW,$pLcpjT,$pLcpjT]);   
  }
 }
}