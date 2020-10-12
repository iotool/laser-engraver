/* create laser cut stencil

 * download stencil font ttf
 * install font ttf to windows
 * create 3D model with openscad
 * convert to 2D projection F6 key
 * export DXF file with 2D model

 * de.caff DXF Viewer oeffnen
 * Option weisser Hintergrund
 * Datei speichern als PNG
 
 * Laser Engraving Mashine starten
 * PNG oeffnen / drag & drop
 * contrast 253, power 100, depth 100
 */

projection(cut = true)
 Model3D();

module Model3D() {

 linear_extrude(10)
  text("TEST",font="Sylar");

}
