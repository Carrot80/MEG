 


    


function for_all_subjects  

      PatientFolder = 'D:\kirsten_thesis\data\patients\';
    
     SelectSubjects (PatientFolder)
%      SelectSubjects (PatientFolder)
end


function SelectSubjects (Mainfolder)

    List = dir( Mainfolder );

 for i = 1 : size (List)
      if ( 0 == strcmp( List(i,1).name, '.') && 0 == strcmp( List(i,1).name, '..') )
          SubjectPath = strcat(Mainfolder, List(i,1).name) ;
          SubjectName = List(i,1).name  
          
        
          SAM_Trigger (SubjectPath, SubjectName)
           
     
      end

 end
 
 
end

function SAM_Trigger (SubjectPath, SubjectName)

    File = strcat(SubjectPath, filesep, 'MEG\02_PreProcessing\','MarkerFile.mrk');
    if exist(File, 'file')
        return 
    end

    [fileName]=PathForFileName(SubjectPath, SubjectName)

    if isempty(fileName)
        return
    end
    
     cd(strcat(SubjectPath, filesep, 'MEG\02_PreProcessing\'));
     
     hdr                     = ft_read_header(fileName) ;
     cfg = [] ;
     cfg.dataset             = fileName ;
     cfg.channel             = 'MEG' 
     data = ft_definetrial(cfg)
     
     trl=data.trl;

   
     load(strcat(SubjectPath, filesep, 'MEG\02_PreProcessing\', 'CleanData_ICA.mat'));
     [tf,loc] = ismember(trl(:,1),CleanData_ICA.sampleinfo(:,1));
     ExcludedTrials=find(tf==0)
     trl(ExcludedTrials,:)=[];
     
         
    trl_SAM = (trl(:,1)-trl(:,3))./1017.25
    
    save trl_SAM trl_SAM
    trl_Mark=Trig2mark('VG', trl_SAM')
    
end

   

    function      [fileName]=PathForFileName(SubjectPath, SubjectName)        
    
     
     PathfileNameHBcor=strcat(SubjectPath, filesep,'MEG\01_Input_no_noisereduction', filesep, 'hb_tr_lf_c,rfhp0.1Hz') ;
     PathfileNameHBcorNoTr=strcat(SubjectPath, filesep, 'MEG\01_Input_no_noisereduction',filesep,'hb_lf_c,rfhp0.1Hz') ;
     PathfileNameNoHBcor=strcat(SubjectPath, filesep, 'MEG\01_Input_no_noisereduction',filesep,'tr_lf_c,rfhp0.1Hz') ;
     PathfileNameLfcor=strcat(SubjectPath, filesep, 'MEG\01_Input_no_noisereduction',filesep,'lf_c,rfhp0.1Hz') ;

     if exist (PathfileNameHBcor, 'file')
         fileName=PathfileNameHBcor;
     elseif exist (PathfileNameHBcorNoTr, 'file')
         fileName=PathfileNameHBcorNoTr;
     elseif exist(PathfileNameNoHBcor, 'file')
         fileName=PathfileNameNoHBcor;
     elseif exist(PathfileNameLfcor, 'file')
         fileName=PathfileNameLfcor
         
     else 
         
         fileName = [];
 
                 
         
    end
    end