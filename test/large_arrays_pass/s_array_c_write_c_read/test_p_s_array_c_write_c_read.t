Tests Large Arrays Pass -> s_array c_write c_read:
  $ wl -i 10000 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 10000
  Execution mode: saf
  
  Fatal error: exception Failure("Size needs to be a concrete integer")
  [2]
  $ wl -i 50000 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 50000
  Execution mode: saf
  
  Fatal error: exception Failure("Size needs to be a concrete integer")
  [2]
  $ wl -i 100000 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 100000
  Execution mode: saf
  
  Fatal error: exception Failure("Size needs to be a concrete integer")
  [2]
