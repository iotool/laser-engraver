// NejeMaster2 FanHolder
// 2020-10-24 V1
// 2020-10-24 V2 bugfix stopper

$bt =   4;  // base dicke
$bl = 106;  // base laenge
$bl = 135;  // base laenge
$bb =  58;  // base breite
$bs = ($bb-30)/2; // base schieben
$cl =  40;  // corner laenge
$cb =  12;  // corner breite
$pl =  19;  // plug laenge
$pb =  14;  // plug breite
$io =  50;  // inner oberhalb
$il =  14;  // inner laenge
$ib =  38;  // inner breite
$fo =  96;  // fan oberhalb
$fr =  24;  // fan radius
$hl1 = 22;  // hole laser oben
$hl2 = 32.5;// hole laser oben
$hl3 = 42;  // hole laser oben
$hlr =  2;  // hole laser radius
$hlg = 16;  // hole laser abstand
$hfo = 96;  // hole fan oben
$hfr =  1.5;// hole fan radius
$hfg = 32;  // hole fan abstand
$hto =  7;  // hole top oben
$htr =  1.5;// hole top radius
$htg = 24;  // hole top abstand
$hdo = 85;  // hole down oben
$hdr =  1.5;// hole down radius
$hdg = 38;  // hole down abstand
$hso = 70;  // hole side oben
$hsr =  1.5;// hole side radius
$hsg = 48;  // hole side abstand
$al =  8;  // adapter laenge
$ab =  4;  // adapter breite
$ag =  22;  // adapter abstand
$ao1 = 72; // adapter oben
$ao2 = 95; // adapter oben
$ao3 = 118; // adapter oben

$gap = 0;  // aufmass
$out = 2;  // 0=3d, 1=2d, 2=debug

if ($out==0) {
 // 3d
 $gap = +1;
 $hlr = $hlr+$gap/2;
 $hfr = $hfr+$gap/2;
 $htr = $htr+$gap/2;
 $hdr = $hdr+$gap/2;
 $hsr = $hsr+$gap/2;
 $al  = $al+$gap/2;
 $ab  = $ab+$gap/2;
 mFanHolder();
}
if ($out==1) {
 // 2d
 $gap = -0.15;
 $hlr = $hlr+$gap/2;
 $hfr = $hfr+$gap/2;
 $htr = $htr+$gap/2;
 $hdr = $hdr+$gap/2;
 $hsr = $hsr+$gap/2;
 $al  = $al+$gap/2;
 $ab  = $ab+$gap/2;
 projection()
  mFanHolder();
}
if ($out==2) {
 // debug
 mFanHolder();
 mDebug();
}

module mFanHolder() {
 difference() {
  translate([0,$bs,0])
   mBase();
  translate([0,$bs,0])
  union() {
   // fan
   mFan();
   // hole fan
   translate([$hfo,0,0])
    union() {
     mHole(0,$hfr,$hfg);
     mHole(1,$hfr,$hfg);
   }
   translate([$hfo+$hfg,0,0])
    union() {
     mHole(0,$hfr,$hfg);
     mHole(1,$hfr,$hfg);
   }
  }
  mPlug();
  translate([31,0,0])
   mHole(1,8.0,50);
  translate([72,0,0])
   mHole(0,9.0,0);
  mCube(0,$il,$ib,-$ib/2,$io);
  // hole laser
  translate([$hl1,0,0])
   union() {
    mHole(0,$hlr,$hlg);
    mHole(1,$hlr,$hlg);
  }
  translate([$hl2,0,0])
   union() {
    mHole(0,$hlr,$hlg);
    mHole(1,$hlr,$hlg);
  }
  translate([$hl3,0,0])
   union() {
    mHole(0,$hlr,$hlg);
    mHole(1,$hlr,$hlg);
  }
  // hole top
  translate([$hto,0,0])
   union() {
    mHole(0,$htr,$htg);
    mHole(1,$htr,$htg);
  }
  // adapter
  mCube(0,$al,$ab,-40,$ao1);
  mCube(0,$al,$ab,-40,$ao2);
  mCube(0,$al,$ab,-40,$ao3);
 }
}

module mHole($p=0,$r,$g) {
 if($p==0){
  translate([0,-$g/2,0])
   cylinder(h=$bt,r=$r,$fn=12);
 } else {
  translate([0,+$g/2,0])
   cylinder(h=$bt,r=$r,$fn=12);
 }
}

module mCube($p=0,$l,$b,$g,$o) {
 if($p==0){
  translate([$o,-$b-$g,0])
   cube([$l,$b,$bt]);
 } else {
  translate([$o,+$g,0])
   cube([$l,$b,$bt]);
 }
}

module mFan() {
 translate([$hfo+$hfg/2,0,0])
  cylinder(h=$bt,r=$hfg/5*3,$fn=18);
}

module mPlug() {
 translate([0,-$pb/2,0])
  cube([$pl,$pb,$bt]);
}

module mBase() {
 color("red")
 translate([0,-$bb/2,0])
  cube([$bl,$bb,$bt]);
}

module mDebug() {
 // screws top
 translate([31,0,0])
  union() {
   mHole(0,5.5,50);
   mHole(1,5.5,50);
 }
 // screw down
 translate([72,0,0])
  mHole(0,5.5,0);
 // plug
 translate([0,-6,0])
  cube([18,12,$bt]);
 // laser
 translate([0,-15,-35])
  cube([110,30,30]);
}    
