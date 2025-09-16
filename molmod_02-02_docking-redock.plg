# YASARA PLUGIN
# TOPIK		: Penapisan Virtual Berbasis Struktur
# JUDUL		: MOLMOD Docking Redocking
# PENULIS	: Enade Perdana Istyastono
# LICENSE	: Hak Cipta 2025 Enade Perdana Istyastono   
# DESKRIPSI	: Plugin ini dirancang untuk membuat Molecular Docking untuk Virtual Screening menjadi lebih user friendly.
#
"""
MainMenu: Options
  PullDownMenu after MOLMOD.ID: MOLMOD.ID docking
    SubMenu after Preparation: Redocking
      Request: None
"""

if not Structure
  RaiseError "This plugin requires YASARA Structure"

Console Off
Clear

WD,LigRes,RepNo=
  ShowWin Type=TextInput,Title="Input File",
          Text="Please define the input file (no space, without extension):",
		  Text="_P_ath to the working directory:",
          Text="_L_igand residue name (3-letter-code):,Lig",
          Text="Replication _f_requency:,100"
		  
if (RepNo)>999
  RaiseError 'Too many docking replications, the simulations could take forever'
  
CD (WD)
Shell mkdir redocking
CD redocking
LoadYOb ..\ref_ligand.yob,Transfer=No
TransformObj 1,KeepPos=No
ForceField AMBER14,SetPar=Yes
Interactions Bond,Angle,Dihedral,Planarity,Coulomb,VdW
Experiment Minimization
Experiment On
Wait ExpEnd
SaveYOb 1,tmp-ligand.yob
Clear

for i=001 to (RepNo)
  Shell mkdir dock_(i)
  CD dock_(i)
  docknum=(i)
  CopyFile ..\..\dock_receptor.sce, dock_receptor.sce 
  CopyFile ..\tmp-ligand.yob, dock_ligand.yob
  MacroTarget = './dock'
  RandomSeed Time
  include dock_run.mcr
  Console Off
  Clear
  CopyFile ..\..\ref_ligand.yob, ref_ligand.yob
  LoadYOb ref_ligand.yob
  LoadYOb dock_001.yob
  DelRes !(LigRes)
  TransferObj 2,1
  DelAtom Element H
  LogAs rmsd_bestpose.txt
  RMSDObj 1,2,Match=AtomName+AltLoc,Flip=Yes,Unit=Obj
  DelFile ref_ligand.yob
  DelFile dock_ligand.yob
  DelFile dock_receptor.yob
  Shell wsl grep dock rmsd_bestpose.txt | wsl awk '{print "RMSD the best pose from dock_(docknum) to the reference ligand = "$9" angstrom."}' >> ../rmsd_bestpose_all.txt
  Clear
  Shell del *.adr *.pdbqt
  CD ..
  Clear
DelFile tmp-ligand.yob

LoadYOb ..\ref_ligand.yob,Transfer=No
for i=001 to (RepNo)
  LoadYOb dock_(i)\dock_001.yob,Transfer=Yes
DelRes !(LigRes)
HideAtom Element H with bond to Element C
ZoomAll Steps=20
HUD Off
Style Stick
ColorObj 1,Magenta
SavePNG overlay.png
Hud Obj

WriteReport Title,Filename=report-redocking,Text='Redocking Report'
WriteReport Heading,2,'Overlay of the best poses to the reference ligand'
WriteReport Image,Filename=overlay.png,Style=Figure, Caption = 'Overlay of the best poses to the reference ligand. Note: The reference ligand in magenta.'
WriteReport Heading,2,'RMSD to the reference ligand'
for line in file rmsd_bestpose_all.txt
  WriteReport Paragraph,'(line)'
WriteReport Heading,2,'Notes:'
WriteReport Paragraph,''
WriteReport Paragraph,'a. The docking protocol can be recommended for further use if more than 95% of the RMSD values are less than 2.0 angstrom.'
WriteReport Paragraph,'b. The file for Figure 1: "file://overlay.png"'
WriteReport Paragraph,'c. The RMSD values file: "file://rmsd_bestpose_all.txt"'
WriteReport End
CD ..
choice = ShowWin Type=RadioButton,Title="The redocking simulations have been completed.", Text="The report was prepared and stored in the file report-redocking.html.", Text="_E_xit and show the report, or", Text="_C_ontinue using YASARA."
if (choice) == 2
  ShowButton Continue
  Wait Button
  Clear
if (choice) == 1
  ShowURL redocking\report-redocking.html
  Wait 7,Unit=Seconds  
  Exit
