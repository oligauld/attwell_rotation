% this loads MI and energy data generated by the batch script and makes plots 

gsyn_scale_factors = [0,1,5,10,15,20,25,30,40,50,70,90,100];
noise_scale_factors = [0.1,0.5,1,1.125,1.25,2];


for pp = 1:length(noise_scale_factors)
    noise_scaler = noise_scale_factors(pp);
    
    for p = 1:length(gsyn_scale_factors)
        gsyn_scaler = gsyn_scale_factors(p);
   
        fname2 = ['output/new_noise_model/noisescale_' num2str(noise_scaler) '/gsyn_' num2str(gsyn_scaler) '_SummaryParams.mat'];
        load(fname2);

        MI_data(pp,p) = MI_energy_params(1); 
        Energy_data(pp,p)= MI_energy_params(4);
        Hnoise_data(pp,p) = MI_energy_params(3);
        Htotal_data(pp,p) = MI_energy_params(2);

        fname1 = ['output/new_noise_model/noisescale_' num2str(noise_scaler) '/gsyn_' num2str(gsyn_scaler) '.mat'];
        load(fname1)
        
        mean_freq_Hz(pp,p) = mean(horzcat(data_store{:,3}));
               
    end
end

EnergyEfficiency = MI_data ./ Energy_data;
MIperSpike = MI_data ./ mean_freq_Hz;

Energy_on_current = Energy_data - (mean_freq_Hz .* 60680000)
currentEnergyEfficiency = MI_data ./ Energy_on_current;

CapacityEffiency = MI_data ./ Htotal_data;
CapacityEffiency(isnan(CapacityEffiency))=0;
CapacityEffiency = CapacityEffiency*100;

CapacityEnergyEfficiency = CapacityEffiency ./ Energy_data;


xaxis = 2.*gsyn_scale_factors; % to get x axis ticks, 2 = original amplitude of EPSConductance wave
cc=hsv(length(noise_scale_factors));
mark = {'-o','-x','-d','-*','-<','->'}

figure(1)
%%% plot as function of gSyn
for myplot = 1:length(EnergyEfficiency(:,1))
    % xaxis is gSyn in nS
    % Mutual Info
    
   subplot(3,3,1)
      plot(xaxis,MI_data(myplot,:),mark{myplot},'color',cc(myplot,:))
      hold on     
      title('Mutual Info')
      ylabel('bits/sec')
      xlabel('gsyn [nS]')
      legend
      
          %AP freq
   subplot(3,3,2)
      plot(xaxis,MIperSpike(myplot,:),mark{myplot},'color',cc(myplot,:))
      hold on  
      title('MI per Spike')
      xlabel('gsyn [nS]')
      ylabel('bits/APspike')    
            
    % Energy
   subplot(3,3,3)
      plot(xaxis,Energy_data(myplot,:),mark{myplot},'color',cc(myplot,:))
      hold on   
      title('ATP (current + APs)')
      ylabel('ATP/sec')
      xlabel('gsyn [nS]')
    % Energy
    
   subplot(3,3,4)
      plot(xaxis,Energy_on_current(myplot,:),mark{myplot},'color',cc(myplot,:))
      hold on   
      title('ATP on current only')
      ylabel('ATP/sec')
      xlabel('gsyn [nS]')

   % MI / Energy
   subplot(3,3,5)
      plot(xaxis,currentEnergyEfficiency(myplot,:),mark{myplot},'color',cc(myplot,:))
      hold on   
      title('Information Efficiency (current energy only)')
      ylabel('bits/ATP')
      xlabel('gsyn [nS]')

       % MI / Energy
   subplot(3,3,6)
      plot(xaxis,EnergyEfficiency(myplot,:),mark{myplot},'color',cc(myplot,:))
      hold on   
      title('Information Efficiency (current + AP energy)')
      ylabel('bits/ATP')
      xlabel('gsyn [nS]')
      

   %AP freq
   subplot(3,3,7)
      plot(xaxis,mean_freq_Hz(myplot,:),mark{myplot},'color',cc(myplot,:))
      hold on  
      title('AP freq.')
      xlabel('gsyn [nS]')
      ylabel('Freq. Hz')
      
         %AP freq
   subplot(3,3,8)
      plot(xaxis,CapacityEffiency(myplot,:),mark{myplot},'color',cc(myplot,:))
      hold on  
      title('Capacity Effiency.')
      xlabel('gsyn [nS]')
      ylabel('total capacity')
               
      %AP freq
   subplot(3,3,9)
      plot(xaxis,CapacityEnergyEfficiency(myplot,:),mark{myplot},'color',cc(myplot,:))
      hold on  
      title('Capacity Energy Effiency.')
      xlabel('gsyn [nS]')
      ylabel('units?')
      
end

%%% plot as function of gNoise

figure(2)
cc=hsv(length(EnergyEfficiency(1,:)));
xaxis = 3.45.*noise_scale_factors; % to get x axis ticks, 2 = original amplitude of EPSConductance wave

for myplot = 1:2:length(EnergyEfficiency(1,:))
    % xaxis is gSyn in nS
    % Mutual Info
    
   subplot(2,4,1)
      plot(xaxis,MI_data(:,myplot),'color',cc(myplot,:))
      hold on     
      title('Mutual Info')
      ylabel('bits/sec')
      xlabel('gNoise mean [nS]')
      legend
      
          %AP freq
   subplot(2,4,2)
      plot(xaxis,MIperSpike(:,myplot),'color',cc(myplot,:))
      hold on  
      title('MI per Spike')
      xlabel('gNoise mean [nS]')
      ylabel('bits/APspike')    
            
    % Energy
   subplot(2,4,3)
      plot(xaxis,Energy_data(:,myplot),'color',cc(myplot,:))
      hold on   
      title('ATP (current + APs)')
      ylabel('ATP/sec')
      xlabel('gNoise mean [nS]')
    % Energy
    
   subplot(2,4,4)
      plot(xaxis,Energy_on_current(:,myplot),'color',cc(myplot,:))
      hold on   
      title('ATP on current only')
      ylabel('ATP/sec')
      xlabel('gNoise mean [nS]')

   % MI / Energy
   subplot(2,4,5)
      plot(xaxis,currentEnergyEfficiency(:,myplot),'color',cc(myplot,:))
      hold on   
      title('Information Efficiency (current energy only)')
      ylabel('bits/ATP')
      xlabel('gNoise mean [nS]')

       % MI / Energy
   subplot(2,4,6)
      plot(xaxis,EnergyEfficiency(:,myplot),'color',cc(myplot,:))
      hold on   
      title('Information Efficiency (current + AP energy)')
      ylabel('bits/ATP')
      xlabel('gNoise mean [nS]')
      

   %AP freq
   subplot(2,4,7)
      plot(xaxis,mean_freq_Hz(:,myplot),'color',cc(myplot,:))
      hold on  
      title('AP freq.')
      xlabel('gNoise mean [nS]')
      ylabel('Freq. Hz')
      
end