function actions(cmnd)

global x TablesData

switch cmnd
    case 'loadSpikes'
        x.spikes=[];
        i=get(x.handles.TableEntry,'Value');
        u=get(x.handles.SpikeEntry,'Value');
        %         monks = get(x.handles.MonkeySel,'String');
        monks =  get (x.handles.MonkeySel,'Value');
        x.filepath = TablesData{monks,2};
        %         x.filepath = get_path( monks );
        trialCounter=0;
        x.precue=str2num(get(x.handles.PreCue,'string'));
        x.postcue=str2num(get(x.handles.PostCue,'string'));
        x.prego=str2num(get(x.handles.PreGo,'string'));
        x.postgo=str2num(get(x.handles.PostGo,'string'));
        x.window=str2num(get(x.handles.window,'string'));
        duration=x.postgo-x.prego+1+x.postcue-x.precue+1+x.window;
        validity=[];
        wvfFlag=1;
        for j=x.table(i).extens(1):x.table(i).extens(2)
            fnm=sprintf('%s%s.%d.mat',x.filepath, x.table(i).fnm,j);
            load(fnm);
            tspikeStr=['Tspike' num2str(x.table(i).sp(u).id)];            
            if exist(tspikeStr)
                flag=1;
                eval(['Tspike=' tspikeStr ';']);
            else
                flag=0;
            end
            if ~wvfFlag
                wvffnm=sprintf('g:\\gaya\\waveforms\\%sw.%d.mat',x.table(i).fnm(1:end-2),j);
                load(wvffnm);
                var2search=['waveform' num2str(x.table(i).sp(u).id) 'Mean'];   
                if exist(var2search)
                    axes(x.handles.wvf), plot(eval(var2search));, axis tight
                    wvfFlag=1;
                end
            end
            for ti=1:size(trials,1)
                trialCounter=trialCounter+1;
                validity(trialCounter)=vTrial(ti,bhvStat);
                events=events_code(trials(ti,1):trials(ti,2));
                t=returnTarget(events);                
                ev1=returnEvPosition(events, t, 'cue')+trials(ti,1)-1;
                ev2=returnEvPosition(events, t, 'go')+trials(ti,1)-1;
                %ev2=returnEvPosition(events, t, 'to')+trials(ti,1)-1;
                if flag
                    refTime1=events_time(ev1);
                    refTime2=events_time(ev2);
                    tmpSpikes1=Tspike(find(Tspike>=refTime1+x.precue & Tspike<=refTime1+x.postcue))-refTime1-x.precue+1;
                    tmpSpikes2=Tspike(find(Tspike>=refTime2+x.prego & Tspike<=refTime2+x.postgo))-refTime2-x.prego+1;
                    x.spikes(trialCounter,:)=[turn2row(time2bin(round(tmpSpikes1),x.postcue-x.precue+1)) zeros(1,x.window) turn2row(time2bin(round(tmpSpikes2),x.postgo-x.prego+1))];            
                else
                    x.spikes(trialCounter,:)=zeros(1,duration);            
                end
                x.handPosition(trialCounter)=hand_position;
                x.targets(trialCounter)=t;
            end%for ti
        end %of for j
        if size(validity,1)==size(x.table(i).sp(u).trials,1),
            validity = validity';
        end
        x.PronIndex=find(x.table(i).sp(u).trials==1 & validity');%find(x.handPosition==1);
        x.SupIndex=find(x.table(i).sp(u).trials==2 & validity');%find(x.handPosition==2);
        if isempty(x.PronIndex) & isempty(x.SupIndex) & ~isempty( find(x.table(i).sp(u).trials==3 & validity')),
            disp('We have only trials in mid position setting it to be pronation');
            x.PronIndex=find(x.table(i).sp(u).trials==3 & validity');%find(x.handPosition==1);
        end
        x.currentStart=x.postcue-x.precue-x.prego+x.window ;% 1;
        x.step=str2num(get(x.handles.step,'string'));
        actions('computePD');
        actions('drawRaster');
    case 'computePD'
        r=[]; t=[];        
        for i=1:length(x.PronIndex)        
            r(i)=sum(x.spikes(x.PronIndex(i),x.currentStart:x.currentStart+x.window));
            t(i)=x.targets(x.PronIndex(i));
        end
        if ~isempty(r)
            [x.pronPD,p,tet,ratetet,Rwin,Rboot]=computePD(t,r,5,15,2);
        else
            x.pronPD=nan;
            p=1;
            tet=[]; Rwin=[]; ratetet=[]; Rboot=[];
        end
       if p<0.05
           axes(x.handles.pronPD), cla
           if ~isempty(tet)
               polar(tet([1:end 1]), ratetet([1:end 1])), hold on, 
           end
           polar([x.pronPD x.pronPD],[0 max(ratetet)],'g'), hold off
           title(num2str(p))
           % %            axes(x.handles.BootPron), cla
           % %            if ~isempty(tet),
           % %                 hist(Rboot,50), hold on, plot([Rwin Rwin],[0 100],'r'), hold off
           % %            end
       else
           axes(x.handles.pronPD), cla
           if ~isempty(tet)
               polar(tet([1:end 1]), ratetet([1:end 1])), hold on, 
               title(['non directional (p=' num2str(p) ')'])                   
           end
           % %            axes(x.handles.BootPron), cla
           % %            if ~isempty(tet)
           % %                hist(Rboot,50), hold on, plot([Rwin Rwin],[0 100],'r'), hold off
           % %            end
       end
        r=[]; t=[];
        for i=1:length(x.SupIndex)        
            r(i)=sum(x.spikes(x.SupIndex(i),x.currentStart:x.currentStart+x.window));
            t(i)=x.targets(x.SupIndex(i));
        end        
        if ~isempty(r)
            [x.supPD,p,tet,ratetet,Rwin,Rboot]=computePD(t,r,5,15,2);
        else
            x.supPD=nan;
            p=1;
            tet=[]; Rwin=[]; ratetet=[]; Rboot=[];
        end
        if p<0.05
            axes(x.handles.supPD), cla
            if ~isempty(tet), 
                polar(tet([1:end 1]), ratetet([1:end 1])), hold on,                
            end
            polar([x.supPD x.supPD],[0 max(ratetet)],'g'), hold off            
            title(num2str(p))
            % %             axes(x.handles.BootSup), cla
            % %             if ~isempty(tet),
            % %                 hist(Rboot,50), hold on, plot([Rwin Rwin],[0 100],'r'), hold off
            % %             end
        else
            axes(x.handles.supPD), cla            
           if ~isempty(tet)
               polar(tet([1:end 1]), ratetet([1:end 1])), hold on,                                                 
               title(['non directional, p=(' num2str(p) ')'])
           end
            
           % %             axes(x.handles.BootSup), cla
           % %             if ~isempty(tet)
           % %                 hist(Rboot,50), hold on, plot([Rwin Rwin],[0 100],'r'), hold off
           % %             end
        end
    case 'right_slide'
        x.step=str2num(get(x.handles.step,'string'));
        tmpX1=get(x.win11,'xdata');
        set(x.win11,'xdata',tmpX1+x.step)
        tmpX2=get(x.win21,'xdata');
        set(x.win21,'xdata',tmpX2+x.step)
        tmpX3=get(x.win12,'xdata');
        set(x.win12,'xdata',tmpX3+x.step)
        tmpX4=get(x.win22,'xdata');
        set(x.win22,'xdata',tmpX4+x.step)
        tmpX5=get(x.win33,'xdata');
        set(x.win33,'xdata',tmpX5+x.step)
        tmpX6=get(x.win34,'xdata');
        set(x.win34,'xdata',tmpX6+x.step)
        tmpX7=get(x.win43,'xdata');
        set(x.win43,'xdata',tmpX7+x.step)
        tmpX8=get(x.win44,'xdata');
        set(x.win44,'xdata',tmpX8+x.step)
        x.currentStart=x.currentStart+x.step;
        if x.currentStart>x.postgo+x.postcue-x.prego-x.precue-x.window
            x.currentStart=x.postgo+x.postcue-x.prego-x.precue-x.window;
            set(x.win11,'xdata',tmpX1)
            set(x.win12,'xdata',tmpX2)
            set(x.win21,'xdata',tmpX3)
            set(x.win22,'xdata',tmpX4)
            set(x.win33,'xdata',tmpX5)
            set(x.win34,'xdata',tmpX6)
            set(x.win43,'xdata',tmpX7)
            set(x.win44,'xdata',tmpX8)
        end        
        actions('computePD');
    case 'left_slide'
        x.step=str2num(get(x.handles.step,'string'));
        x.currentStart=x.currentStart-x.step;
        tmpX1=get(x.win11,'xdata');
        set(x.win11,'xdata',tmpX1-x.step)
        tmpX2=get(x.win21,'xdata');
        set(x.win21,'xdata',tmpX2-x.step)
        tmpX3=get(x.win12,'xdata');
        set(x.win12,'xdata',tmpX3-x.step)
        tmpX4=get(x.win22,'xdata');
        set(x.win22,'xdata',tmpX4-x.step)
        tmpX5=get(x.win33,'xdata');
        set(x.win33,'xdata',tmpX5-x.step)
        tmpX6=get(x.win34,'xdata');
        set(x.win34,'xdata',tmpX6-x.step)
        tmpX7=get(x.win43,'xdata');
        set(x.win43,'xdata',tmpX7-x.step)
        tmpX8=get(x.win44,'xdata');
        set(x.win44,'xdata',tmpX8-x.step)
        if x.currentStart<1 
            x.currentStart=1;
            set(x.win11,'xdata',tmpX1)
            set(x.win12,'xdata',tmpX3)
            set(x.win21,'xdata',tmpX2)
            set(x.win22,'xdata',tmpX4)
            set(x.win33,'xdata',tmpX5)
            set(x.win34,'xdata',tmpX6)
            set(x.win43,'xdata',tmpX7)
            set(x.win44,'xdata',tmpX8)
        end
        actions('computePD');
    case 'drawRaster'
        tmpSpikes=x.spikes(x.PronIndex,:);
        [s,i]=sort(x.targets(x.PronIndex));
        [u,ui]=unique(s);
        ui=[0 ui];
        tmpSpikes=tmpSpikes(i,:);
        xxx=[];
        yyy=[];
        for i=1:size(tmpSpikes,1)
                tmp=turn2row(find(tmpSpikes(i,:)));%+x.pre-1;
                if ~isempty(tmp)
                    xxx=[xxx reshape([i-1; i-.2; nan]*ones(1,size(tmp,2)),1,[])];
                    yyy=[yyy reshape([tmp;tmp;nan*(ones(1,length(tmp)))],1,[])];
                end
        end
        axes(x.handles.pronRaster), cla, plot(yyy,xxx,'k'); axis tight, hold on
        a=axis;
        for i=1:length(ui)-1
            plot([a(1) a(2)],[ui(i)+.5 ui(i)+.5],'k--'); 
            text(x.postgo+x.postcue-x.prego-x.precue-x.window,.5*(ui(i)+ui(i+1)),num2str(u(i)),'fontsize',18)
        end
        plot(-[x.precue x.precue],[a(3) a(4)],'r--')
        plot([x.postcue-x.precue-x.prego+x.window x.postcue-x.precue-x.prego+x.window],[a(3) a(4)],'r--')
        x1=x.currentStart;%+x.pre-1;
        x2=x1+x.window;
        y1=a(3); y2=a(4);
        x.win11=plot([x1 x2],[0 0],'g');
        x.win12=plot([x1 x1],[y1 y2],'g','LineWidth',2);
        x.win21=plot([x2 x2],[y1 y2],'g','LineWidth',2);
        x.win22=plot([x1 x2],[y2 y2],'g');
%         x.win1=patch([x1 x2 x2 x1 x1],[y1 y1 y2 y2 y1],[.1 .1 .1])
%         g=get(x.handles.pronRaster,'children');
%         set(g(1),'facealpha',.2)
        
        tmpSpikes=x.spikes(x.SupIndex,:);
        [s,i]=sort(x.targets(x.SupIndex));
        tmpSpikes=tmpSpikes(i,:);
        [u,ui]=unique(s);
        ui=[0 ui];
        xxx=[];
        yyy=[];
        for i=1:size(tmpSpikes,1)
                tmp=turn2row(find(tmpSpikes(i,:)));%+x.pre-1;
                if ~isempty(tmp)
                    xxx=[xxx reshape([i-1; i-.2; nan]*ones(1,size(tmp,2)),1,[])];
                    yyy=[yyy reshape([tmp;tmp;nan*(ones(1,length(tmp)))],1,[])];
                end
        end
        axes(x.handles.supRaster), cla, plot(yyy,xxx,'k'); axis tight, hold on
        a=axis;
        for i=1:length(ui)-1
            plot([a(1) a(2)],[ui(i)+.5 ui(i)+.5],'k--'); 
            text(x.postgo+x.postcue-x.prego-x.precue-x.window,.5*(ui(i)+ui(i+1)),num2str(u(i)),'fontsize',18)
        end
        plot(-[x.precue x.precue],[a(3) a(4)],'r--')
        plot([x.postcue-x.precue-x.prego+x.window x.postcue-x.precue-x.prego+x.window],[a(3) a(4)],'r--')
        x1=x.currentStart;%+x.pre-1;
        x2=x1+x.window;
        y1=a(3); y2=a(4);
        x.win33=plot([x1 x2],[0 0],'g');
        x.win34=plot([x1 x1],[0 y2],'g','LineWidth',2);
        x.win43=plot([x2 x2],[0 y2],'g');
        x.win44=plot([x1 x2],[y2 y2],'g');
        t2pst = get_target2psth( x.handles);
        if ~isempty(t2pst),
            ProSpikes =  get_spikes4targets( x.spikes(x.PronIndex,:), x.targets(x.PronIndex), t2pst);
            SupSpikes =  get_spikes4targets( x.spikes(x.SupIndex,:), x.targets(x.SupIndex), t2pst);
            pstbin = str2double(get(x.handles.PSTBIN,'string'));
            [prox,propst] = binvector( ProSpikes,pstbin, x.precue,x.postcue, x.window, x.prego, x.postgo);
            [supx,suppst] = binvector( SupSpikes,pstbin, x.precue,x.postcue, x.window, x.prego, x.postgo);
            [xp, yp] = stairs(prox, propst);
            plot(x.handles.proPST,xp,yp,'r','linewidth',2)
            [xp,yp]=stairs(supx, suppst);
            plot(x.handles.supPST,xp,yp,'r','linewidth',2)
                        
        end
        %x.win2=patch([x1 x2 x2 x1 x1],[y1 y1 y2 y2 y1],[.1 .1 .1]), set(x.win2,'facealpha',.2)
end%of switch


function bool=vTrial(ti,bhvStat)
bool=0;
if bhvStat(ti,1)<=500 && bhvStat(ti,2)<=1500  && abs(bhvStat(ti,5))<=35  && abs(bhvStat(ti,6))<=20 %&& bhvStat(ti,7)>500 &&  bhvStat(ti,7)<1500 &&  bhvStat(ti,11)<=10 &&  bhvStat(ti,12)<=25 &&  bhvStat(ti,13)<=10
    bool=1;
end



function   filepath = get_path( monks )

filepath = '';
switch (lower( monks)),
    case 'darma',
        %         filepath = 'm:\darma\combinedData_TRQ\';
        filepath = 'y:\darma\combinedData_TRQ\';
    case 'gaya',
        filepath =  'm:\gaya\gayaEdfilesAll\tmp\';
    case {'vega','vsct', 'vegayifat'},
        filepath = '\vega\data\vegaedfiles\';
        %         filepath = 'm:\vega\vegaedfiles_nofy\';
    case {'hugo'},
        filepath = '\Hugo\HugoCorticalData\EdFiles\';
	case {'vsct_edited'},
        filepath = '\vega\data\sct_eefiles\';
    case {'hugoscp'},
        filepath = '\hugo\hugodata\edfilesall\';
    case {'hugoctx'},
        filepath = '\hugo\hugocorticaldata\edfilesall\';
    case {'hugospinal'},
        filepath = '\hugo\hugodata\edfilesall\';
end

    
function  t2pst = get_target2psth( xh)

for i=1:8,
    t2pst(i) = eval(['get( xh.TRG' num2str(i) ',''Value'');']);
end
t2pst = find(t2pst);
    
function Spikes =  get_spikes4targets( AllSpikes, targets, targets2pst)

Spikes = AllSpikes(find(ismember(targets,targets2pst)),:);

function [x,y] = binvector( pst,binsize, precue,postcue, deadwindow, prego, postgo)

t1 = precue;
t2 = t1+postcue-precue+deadwindow+(postgo-prego);
pst = sum(pst);
r = mod(length(pst),binsize);
y = mean(reshape(pst(1:end-r),binsize,[]));
x = t1:binsize:t2;
x = x(1:length(y));


