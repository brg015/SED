S={'SAM2_subject1000' 'SAM2_subject1001' 'SAM2_subject1003'};
HC=1; % HC handle

for ii=1:length(S),
   % Load subject files
   f1=excel_reader(fullfile('\\ccn-cabezaserv1.win.duke.edu\Data2\SED\',S{ii},'SAM_part1','SAM_save.csv'));
   f2=excel_reader(fullfile('\\ccn-cabezaserv1.win.duke.edu\Data2\SED\',S{ii},'SAM_part2','SAM_save.csv'));
   f3=excel_reader(fullfile('\\ccn-cabezaserv1.win.duke.edu\Data2\SED\',S{ii},'SAM_part3','SAM_save.csv'));
   for jj=1:6
       f1{jj}.col=cell2num(f1{jj}.col);
       f2{jj}.col=cell2num(f2{jj}.col);
       f3{jj}.col=cell2num(f3{jj}.col);
   end
   
   % Encoding Hits
   EH(ii)=(sum(f1{3}.col==1 & f1{6}.col==1) + sum(f1{3}.col==0 & f1{6}.col==2))/600;
   RT_E=cell2num(f1{end}.col);
   Ttype=f1{5}.col;
   
   for jj=1:2
       switch jj
           case 1, ret=f2; ret_Ttype=zeros(1,900); RT_R=zeros(1,900);
           case 2, ret=f3; ret_Ttype=zeros(1,600); RT_R=zeros(1,600);
       end
       % Conceptual & Perceptual loops (Rem/For First)
       % Sort trials by encoding
       
       [C,IA,IB]=intersect(f1{4}.col,ret{4}.col);
 
       ret_Ttype(IB)=Ttype(IA); % Easy trial sort by ENC type
       RT_R(IB)=RT_E(IA);
       
       if HC==1
           Lo=strcmp(ret{end}.col,'Lo');
           for aa=1:length(ret), ret{aa}.col(Lo)=[]; end
           ret_Ttype(Lo)=[];
           RT_R(Lo)=[];   
       end
       
       RESP=ret{7}.col;
       % CR and FA rates first
       CR=sum(strcmp(RESP,'CR'))/sum(~ret{3}.col);
       FA=sum(strcmp(RESP,'FA'))/sum(~ret{3}.col);
       if jj==1
           for kk=1:3
               I1=(ret_Ttype==kk);
               HCn(kk)=sum(I1);
               Rem(kk)=sum(strcmp(RESP(I1),'HIT'))/sum(I1);
               For(kk)=sum(strcmp(RESP(I1),'MISS'))/sum(I1);
               a=RT_R(I1);
               Rem_RT(kk)=mean(a(strcmp(RESP(I1),'HIT')));
               For_RT(kk)=mean(a(strcmp(RESP(I1),'MISS')));
               OLD_RT(kk)=mean(a);
               clear a;
           end
       else
            for kk=1:3
               I1=(ret_Ttype==kk & ret{3}.col==1);
               HCn(kk)=sum(I1);
               Rem(kk)=sum(strcmp(RESP(I1),'HIT'))/sum(I1);
               For(kk)=sum(strcmp(RESP(I1),'MISS'))/sum(I1);
               a=RT_R(I1);
               Rem_RT(kk)=mean(a(strcmp(RESP(I1),'HIT')));
               For_RT(kk)=mean(a(strcmp(RESP(I1),'MISS')));
               OLD_RT(kk)=mean(a);
               clear a;
               sum(I1)
            end
       end
       R{jj}=[Rem For CR FA];
       RT{jj}=[Rem_RT For_RT];
       RT4{jj}=[OLD_RT];
       HCnn{jj}=[HCn];
   end
   R2(ii,:)=[R{1} R{2}];
   R3(ii,:)=[RT{1} RT{2}];
   R4(ii,:)=[RT4{1} RT4{2}]; %OLD_RT;
   NHc(ii,:)=[HCnn{1} HCnn{2}];
end
