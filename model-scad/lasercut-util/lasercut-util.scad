// lasercut-util.scad 
// 2020-10-08 add inner joins (-/+0.01 ~ 1)

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
 // no joins [-0.99,+0.99]
 if ($pLcpjF == 0.99) {
  $mLcpjFW = $pLcpjW-$pLcpjT+$pLcpjC;
  $mLcpjFX = -$pLcpjC/2;
  $mLcpjFY = -$pLcpjC/2;
  color("yellow")
  translate([$mLcpjFX,$mLcpjFY,0])
   cube([$mLcpjFW,$pLcpjT,$pLcpjT]);   
 }
 else if ($pLcpjF == -0.99) {
  $mLcpjFW = $pLcpjW-2*$pLcpjT+$pLcpjC;
  $mLcpjFX = -$pLcpjC/2+$pLcpjT;
  $mLcpjFY = -$pLcpjC/2;
  color("gray")
  translate([$mLcpjFX,$mLcpjFY,0])
   cube([$mLcpjFW,$pLcpjT,$pLcpjT]);   
 }
 // outer joins [>=-1,>=+1]
 else if ($pLcpjF >= 1) {
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
 else if ($pLcpjF <= -1) {
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
 // inner joins [<=-0.01,>=+0.01]
 else if ($pLcpjF > 0) {
  $mLcpjFF = $pLcpjF*100;
  $mLcpjFW = ($pLcpjW-$pLcpjT+$pLcpjC*-$pLcpjF)/(2*$mLcpjFF);
  $mLcpjFS = ($pLcpjW-$pLcpjT)/$mLcpjFF;
  $mLcpjFX = $mLcpjFW/2+$pLcpjT/2;
  $mLcpjFY = -$pLcpjC/2;
  color("red")
  for ($mLcpjFN=[1:$mLcpjFF]) {
   translate([$mLcpjFX+$mLcpjFS*($mLcpjFN-1),$mLcpjFY,0])
    cube([$mLcpjFW,$pLcpjT,$pLcpjT]);
  }
 }
 else if ($pLcpjF < 0) {
  $mLcpjFF = -$pLcpjF*100;
  $mLcpjFW = ($pLcpjW-$pLcpjT+$pLcpjC*-$pLcpjF)/(2*$mLcpjFF);
  $mLcpjFS = ($pLcpjW-$pLcpjT)/$mLcpjFF;
  $mLcpjFX = $mLcpjFW/2+$pLcpjT/2;
  $mLcpjFY = -$pLcpjC/2;
  $mLcpjF1 = $mLcpjFW/2+$pLcpjT/2+$pLcpjC/2;
  $mLcpjF9 = $mLcpjFW-$mLcpjF1;
  color("green")
  union() {
   translate([0,$mLcpjFY,0])
   cube([$mLcpjF1,$pLcpjT,$pLcpjT]);
   translate([$mLcpjFW*($mLcpjFF*2)-$mLcpjF9,$mLcpjFY,0]) 
   cube([$mLcpjF9,$pLcpjT,$pLcpjT]);
   if ($mLcpjFF > 1) {
    for ($mLcpjFN=[1:($mLcpjFF-1)]) {
     translate([2*$mLcpjFX+$mLcpjFS*($mLcpjFN-1)+($mLcpjFW/2-$pLcpjT/2),$mLcpjFY,0])
      cube([$mLcpjFW,$pLcpjT,$pLcpjT]);
    }
   }
  }
 }
}
