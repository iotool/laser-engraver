// NejeMaster2 FanHolder
// 2020-10-24 V1

$t =   4;  // base dicke
$l = 106;  // base laenge
$b =  60;  // base breite
$cl = 41;  // corner laenge
$cb = 12;  // corner breite
$pl = 19;  // plug laenge
$pb = 14;  // plug breite
$io = 49;  // inner oberhalb
$il = 31;  // inner laenge
$ib = 38;  // inner breite
$fo = 96;  // fan oberhalb
$fr = 24;  // fan radius

$hl1 = 22;  // hole laser oben
$hl2 = 32.5;// hole laser oben
$hl3 = 42;  // hole laser oben
$hlr =  2;  // hole laser radius
$hlg =  8;  // hole laser abstand
$hfo = 96;  // hole fan oben
$hfr =  1.5;// hole fan radius
$hfg = 32;  // hole fan abstand
$hto =  7;  // hole top oben
$htr =  1.5;// hole top radius
$htg = 24;  // hole top abstand
$hdo = 85;  // hole down oben
$hdr =  1.5;// hole down radius
$hdg = 38;  // hole down abstand
$hso = 55;  // hole side oben
$hsr =  1.5;// hole side radius
$hsg = 46;  // hole side abstand

// remove comment for dxf
// projection()

difference() {
 mBase();
 mPlug();
 mCorner(0);
 mCorner(1);
 mInner();
 mFan();
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
 // hole fan
 translate([$hfo,0,0])
  union() {
   mHole(0,$hfr,$hfg);
   mHole(1,$hfr,$hfg);
 }
 // hole top
 translate([$hto,0,0])
  union() {
   mHole(0,$htr,$htg);
   mHole(1,$htr,$htg);
 }
 // hole down
 translate([$hdo,0,0])
  union() {
   mHole(0,$hdr,$hdg);
   mHole(1,$hdr,$hdg);
 }
 // hole side
 translate([$hso,0,0])
  union() {
   mHole(0,$hsr,$hsg);
   mHole(1,$hsr,$hsg);
 }
}

module mHole($p=0,$r,$g) {
 if($p==0){
  translate([0,-$r-$g/2,0])
   cylinder(h=$t,r=$r,$fn=12);
 } else {
  translate([0,$r+$g/2,0])
   cylinder(h=$t,r=$r,$fn=12);
 }
}

module mCorner($p=0) {
 if($p==0){
  translate([0,-$b/2,0])
   cube([$cl,$cb,$t]);
 } else {
  translate([0,$b/2-$cb,0])
   cube([$cl,$cb,$t]);
 }
}

module mFan() {
 translate([$fr+$fo,0,0])
  cylinder(h=$t,r=$fr,$fn=18);
}

module mInner() {
 translate([$io,-$ib/2,0])
  cube([$il,$ib,$t]);
}

module mPlug() {
 translate([0,-$pb/2,0])
  cube([$pl,$pb,$t]);
}

module mBase() {
 color("red")
 translate([0,-$b/2,0])
  cube([$l,$b,$t]);
}