
  
  fileName = 'hb_lf_c,rfhp0.1Hz';
    p=pdf4D(fileName);

    cleanCoefs = createCleanFile(p, fileName, 'HeartBeat', 0,'byLF',0,'byFFT',1);