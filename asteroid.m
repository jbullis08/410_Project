%data=asteroiddata
data=asteroiddata;

%Separate the data
id=data(:,1); %ID3
full_name=data(:,2); %Name
a=data(:,3); %Semi Major Axis
e=data(:,4); %Eccentricity of the Orbit
i=data(:,5); %Inclination of the orbit with respect to J2000 ecliptic plane
om=data(:,6); %Longitude of the ascending node
w=data(:,7); %Argument of the perihelion (J2000 ecliptic)
q=data(:,8); %Perihelion distance (comets only)
ad=data(:,9); %Aphelion distance
per_y=data(:,10); %period (years)
data_arc=data(:,11); %data-arc span
condition_code=data(:,12); %condition code
n_obs_used=data(:,13); %# of observations used (total)
n_dop_obs_used=data(:,14); %# of delay radar observations
n_del_obs_used=data(:,15); % of Doppler radar observations used in fit
H=data(:,16); %Absolute Magnitude
diameter=data(:,17); %Diameter (from equivalent sphere)
extent=data(:,18); %Object bi/tri axial ellipsoid dimensions
albedo=data(:,19); %Geometric Albedo
rot_per=data(:,20); %Rotation period
GM=data(:,21); %Mass expressed
BV=data(:,22);  %Color Index BV
UB=data(:,23);  %Color Index UB
IR=data(:,24); %Color Index IR
spec_B=data(:,25); %Spectral Taxonomy Type (SMASSI)
spec_T=data(:,26); %Spectral Taxonomy Type (Tholen)

%convert absolute magnitude to apparent magnitude
%appmag=data(:,16)+5.*(log((4.848e-6).*data(:,9))-1);
%data(:,16)=appmag(:,1);

%
%
%1. Extract out data for asteroids with given albedo range and diameter range
albmin=0.2;
albmax=1.0;
diamin=100;
diamax=1000;
%Extract Albedo Range
data_alb=data([data(:,19)<=albmax & data(:,19)>=albmin],:);
%Extract Diameter Range
data_dia=sortrows(data_alb,17);
data_alb_dia=data_dia([data_dia(:,17)<=diamax & data_dia(:,17)>=diamin],:);
%Sort by name
alb_dia_name=sortrows(data_alb_dia,1);
id1=alb_dia_name(:,1);
dia1=alb_dia_name(:,17);
alb1=alb_dia_name(:,19);
alb_dia=horzcat(id1,dia1,alb1);
length(alb_dia);
alb_dia2=horzcat(dia1,alb1);


%
%
%
%2. Extract out data for asteroids with given albedo range and magnitude range
magmin=0;
magmax=7;
%Extract Albedo Range
data_alb=data([data(:,19)<=albmax & data(:,19)>=albmin],:);
%Extract Magnitude Range
data_mag=sortrows(data_alb,16);
data_alb_mag=data_mag([data_mag(:,16)<=magmax & data_mag(:,16)>=magmin],:);
%Sort by name
alb_mag_name=sortrows(data_alb_mag,1);
id2=alb_mag_name(:,1);
mag=alb_mag_name(:,16);
alb2=alb_mag_name(:,19);
alb_mag=horzcat(id2,mag,alb2);
length(alb_mag);
alb_mag2=horzcat(mag,alb2);

%
%
%
%3. Extract out data for asteroids with given albedo range, diameter range,
%and distance range
dismin=0;
dismax=40;
%Extract Albedo Range
data_alb=data([data(:,19)<=albmax & data(:,19)>=albmin],:);
%Extract Diameter Range
data_dia=sortrows(data_alb,17);
data_alb_dia=data_dia([data_dia(:,17)<=diamax & data_dia(:,17)>=diamin],:);
%Extract Distance Range
data_dis=sortrows(data_alb_dia,9);
data_alb_dia_dis=data_dis([data_dis(:,9)<=dismax & data_dis(:,9)>=dismin],:);
%Sort by name
alb_dia_dis_name=sortrows(data_alb_dia_dis,1);
id3=alb_dia_dis_name(:,1);
dia3=alb_dia_dis_name(:,17);
dis=alb_dia_dis_name(:,9);
alb3=alb_dia_dis_name(:,19);
alb_dia_dis=horzcat(id3,dia3,dis,alb3);
length(alb_dia_dis);
alb_dia_dis2=horzcat(dia3,dis,alb3);

%
%
%
%4. Plot Histogram of Albedos
%The reduced data set consists of the following:
%1=id, 2=absolute mag, 3=diameter, 4=albedo, 5=distance
%use Highcharts basic bar or column chart
reduceddataset=horzcat(data(:,1),data(:,16),data(:,17),data(:,19),data(:,9));


%
%
%
%Find Top 20 Asteroids
top20=[id1;id2;id3];
top20sort=sortrows(top20,1);
top20id=unique(top20sort);
top20asteroidid=top20id;
numtop20=length(top20id);

%Pull out top 20 asteroid names to load into ephemeris module
nameinfo=fullname;
for i=id3
    top20asteroidname=fullname(i,:);
end

%Output list of top20 asteroids
top20asteroidid;
top20asteroidname;

%
%
%
%Ephemerids Data for Pine Mountain Observatory
ephemerids=ephemerids;
%Divide out columns for day of the year and altitude
date=(1:365)';
dec=ephemerids(:,6);
alt=ephemerids(:,15);

%
%
%
angle=30;
%Analysis of ephemerid data for Top 20 asteroids
altJuno=alt(1:365);
decJuno=dec(1:365);
Juno1=horzcat(date,altJuno);
sortJuno1=sortrows(Juno1,2);
Juno1data=sortJuno1([sortJuno1(:,2)>=angle],:);
Juno=sortrows(Juno1data,1);
Junopeak=max(Juno);
Junopeakdays=Juno([Juno(:,2)>=35],:);
Juno2=horzcat(date,decJuno);
sortJuno2=sortrows(Juno2,2);
Juno2data=sortJuno2([sortJuno2(:,2)>=angle],:);
peakJuno=Juno1(:,2).';
csvwrite('Juno',peakJuno);

altVesta=alt(366:730);
decVesta=dec(366:730);
Vesta1=horzcat(date,altVesta);
sortVesta1=sortrows(Vesta1,2);
Vesta1data=sortVesta1([sortVesta1(:,2)>=angle],:);
Vesta=sortrows(Vesta1data,1);
Vestapeak=max(Vesta);
Vestapeakdays=Vesta([Vesta(:,2)>=36],:);
Vesta2=horzcat(date,decVesta);
sortVesta2=sortrows(Vesta2,2);
Vesta2data=sortVesta2([sortVesta1(:,2)>=angle],:);
peakVesta=Vesta1(:,2).';
csvwrite('Vesta',peakVesta);

altAstraea=alt(731:1095);
decAstraea=dec(731:1095);
Astraea1=horzcat(date,altAstraea);
sortAstraea1=sortrows(Astraea1,2);
Astraea1data=sortAstraea1([sortAstraea1(:,2)>=angle],:);
Astraea=sortrows(Astraea1data,1);
Astraeapeak=max(Astraea);
Astraeapeakdays=Astraea([Astraea(:,2)>=37],:);
Astraea2=horzcat(date,decAstraea);
sortAstraea2=sortrows(Astraea2,2);
Astraea2data=sortAstraea2([sortAstraea2(:,2)>=angle],:);
peakAstraea=Astraea1(:,2).';
csvwrite('Astraea',peakAstraea);

altHebe=alt(1096:1460);
decHebe=dec(1096:1460);
Hebe1=horzcat(date,altHebe);
sortHebe1=sortrows(Hebe1,2);
Hebe1data=sortHebe1([sortHebe1(:,2)>=angle],:);
Hebe=sortrows(Hebe1data,1);
Hebepeak=max(Hebe);
Hebepeakdays=Hebe([Hebe(:,2)>=37],:);
Hebe2=horzcat(date,decHebe);
sortHebe2=sortrows(Hebe2,2);
Hebe2data=sortHebe2([sortHebe2(:,2)>=angle],:);
peakHebe=Hebe1(:,2).';
csvwrite('Hebe',peakHebe);

altIris=alt(1461:1825);
decIris=dec(1461:1825);
Iris1=horzcat(date,altIris);
sortIris1=sortrows(Iris1,2);
Iris1data=sortIris1([sortIris1(:,2)>=angle],:);
Iris=sortrows(Iris1data,1);
Irispeak=max(Iris);
Irispeakdays=Iris([Iris(:,2)>=52],:);
Iris2=horzcat(date,decIris);
sortIris2=sortrows(Iris2,2);
Iris2data=sortIris2([sortIris2(:,2)>=angle],:);
peakIris=Iris1(:,2).';
csvwrite('Iris',peakIris);

altFlora=alt(1826:2190);
decFlora=dec(1826:2190);
Flora1=horzcat(date,altFlora);
sortFlora1=sortrows(Flora1,2);
Flora1data=sortFlora1([sortFlora1(:,2)>=angle],:);
Flora=sortrows(Flora1data,1);
Florapeak=max(Flora);
Florapeakdays=Flora([Flora(:,2)>=36],:);
Flora2=horzcat(date,decFlora);
sortFlora2=sortrows(Flora2,2);
Flora2data=sortFlora2([sortFlora2(:,2)>=angle],:);
peakFlora=Flora1(:,2).';
csvwrite('Flora',peakFlora);

altEunomia=alt(2191:2555);
decEunomia=dec(2191:2555);
Eunomia1=horzcat(date,altEunomia);
sortEunomia1=sortrows(Eunomia1,2);
Eunomia1data=sortEunomia1([sortEunomia1(:,2)>=angle],:);
Eunomia=sortrows(Eunomia1data,1);
Eunomiapeak=max(Eunomia);
Eunomiapeakdays=Eunomia([Eunomia(:,2)>=angle],:);
Eunomia2=horzcat(date,decEunomia);
sortEunomia2=sortrows(Eunomia2,2);
Eunomia2data=sortEunomia2([sortEunomia2(:,2)>=angle],:);
peakEunomia=Eunomia1(:,2).';
csvwrite('Eunomia',peakEunomia);

altMelpomene=alt(2556:2920);
decMelpomene=dec(2556:2920);
Melpomene1=horzcat(date,altMelpomene);
sortMelpomene1=sortrows(Melpomene1,2);
Melpomene1data=sortMelpomene1([sortMelpomene1(:,2)>=angle],:);
Melpomene=sortrows(Melpomene1data,1);
Melpomenepeak=max(Melpomene);
Melpomenepeakdays=Melpomene([Melpomene(:,2)>=62],:);
Melpomene2=horzcat(date,decMelpomene);
sortMelpomene2=sortrows(Melpomene2,2);
Melpomene2data=sortMelpomene2([sortMelpomene2(:,2)>=angle],:);
peakMelpomene=Melpomene1(:,2).';
csvwrite('Melpomene',peakMelpomene);

altMassalia=alt(2921:3285);
decMassalia=dec(2921:3285);
Massalia1=horzcat(date,altMassalia);
sortMassalia1=sortrows(Massalia1,2);
Massalia1data=sortMassalia1([sortMassalia1(:,2)>=angle],:);
Massalia=sortrows(Massalia1data,1);
Massaliapeak=max(Massalia);
Massaliapeakdays=Massalia([Massalia(:,2)>=67],:);
Massalia2=horzcat(date,decMassalia);
sortMassalia2=sortrows(Massalia2,2);
Massalia2data=sortMassalia2([sortMassalia2(:,2)>=angle],:);
peakMassalia=Massalia1(:,2).';
csvwrite('Massalia',peakMassalia);

altTahlia=alt(3286:3650);
decTahlia=dec(3286:3650);
Tahlia1=horzcat(date,altTahlia);
sortTahlia1=sortrows(Tahlia1,2);
Tahlia1data=sortTahlia1([sortTahlia1(:,2)>=angle],:);
Tahlia=sortrows(Tahlia1data,1);
Tahliapeak=max(Tahlia);
Tahliapeakdays=Tahlia([Tahlia(:,2)>=angle],:);
Tahlia2=horzcat(date,decTahlia);
sortTahlia2=sortrows(Tahlia2,2);
Tahlia2data=sortTahlia2([sortTahlia2(:,2)>=angle],:);
peakTahlia=Tahlia1(:,2).';
csvwrite('Tahlia',peakTahlia);

altHarmonia=alt(3651:4015);
decHarmonia=dec(3651:4015);
Harmonia1=horzcat(date,altHarmonia);
sortHarmonia1=sortrows(Harmonia1,2);
Harmonia1data=sortHarmonia1([sortHarmonia1(:,2)>=angle],:);
Harmonia=sortrows(Harmonia1data,1);
Harmoniapeak=max(Harmonia);
Harmoniapeakdays=Harmonia([Harmonia(:,2)>=angle],:);
Harmonia2=horzcat(date,decHarmonia);
sortHarmonia2=sortrows(Harmonia2,2);
Harmonia2data=sortHarmonia2([sortHarmonia2(:,2)>=angle],:);
peakHarmonia=Harmonia1(:,2).';
csvwrite('Harmonia',peakHarmonia);

altDaphne=alt(4016:4380);
decDaphne=dec(4016:4380);
Daphne1=horzcat(date,altDaphne);
sortDaphne1=sortrows(Daphne1,2);
Daphne1data=sortDaphne1([sortDaphne1(:,2)>=angle],:);
Daphne=sortrows(Daphne1data,1);
Daphnepeak=max(Daphne);
Daphnepeakdays=Daphne([Daphne(:,2)>=37],:);
Daphne2=horzcat(date,decDaphne);
sortDaphne2=sortrows(Daphne2,2);
Daphne2data=sortDaphne2([sortDaphne2(:,2)>=angle],:);
peakDaphne=Daphne1(:,2).';
csvwrite('Daphne',peakDaphne);

altConcordia=alt(4381:4745);
decConcordia=dec(4381:4745);
Concordia1=horzcat(date,altConcordia);
sortConcordia1=sortrows(Concordia1,2);
Concordia1data=sortConcordia1([sortConcordia1(:,2)>=angle],:);
Concordia=sortrows(Concordia1data,1);
Concordiapeak=max(Concordia);
Concordiapeakdays=Concordia([Concordia(:,2)>=38],:);
Concordia2=horzcat(date,decConcordia);
sortConcordia2=sortrows(Concordia2,2);
Concordia2data=sortConcordia2([sortConcordia2(:,2)>=angle],:);
peakConcordia=Concordia1(:,2).';
csvwrite('Concordia',peakConcordia);

altPanopaea=alt(4746:5110);
decPanopaea=dec(4746:5110);
Panopaea1=horzcat(date,altPanopaea);
sortPanopaea1=sortrows(Panopaea1,2);
Panopaea1data=sortPanopaea1([sortPanopaea1(:,2)>=angle],:);
Panopaea=sortrows(Panopaea1data,1);
Panopaeapeak=max(Panopaea);
Panopaeapeakdays=Panopaea([Panopaea(:,2)>=35],:);
Panopaea2=horzcat(date,decPanopaea);
sortPanopaea2=sortrows(Panopaea2,2);
Panopaea2data=sortPanopaea2([sortPanopaea2(:,2)>=angle],:);
peakPanopaea=Panopaea1(:,2).';
csvwrite('Panopaea',peakPanopaea);

altAurora=alt(5111:5475);
decAurora=dec(5111:5475);
Aurora1=horzcat(date,altAurora);
sortAurora1=sortrows(Aurora1,2);
Aurora1data=sortAurora1([sortAurora1(:,2)>=angle],:);
Aurora=sortrows(Aurora1data,1);
Aurorapeak=max(Aurora);
Aurorapeakdays=Aurora([Aurora(:,2)>=47],:);
Aurora2=horzcat(date,decAurora);
sortAurora2=sortrows(Aurora2,2);
Aurora2data=sortAurora2([sortAurora2(:,2)>=angle],:);
peakAurora=Aurora1(:,2).';
csvwrite('Aurora',peakAurora);

altDynamene=alt(5476:5840);
decDynamene=dec(5476:5840);
Dynamene1=horzcat(date,altDynamene);
sortDynamene1=sortrows(Dynamene1,2);
Dynamene1data=sortDynamene1([sortDynamene1(:,2)>=angle],:);
Dynamene=sortrows(Dynamene1data,1);
Dynamenepeak=max(Dynamene);
Dynamenepeakdays=Dynamene([Dynamene(:,2)>=angle],:);
Dynamene2=horzcat(date,decDynamene);
sortDynamene2=sortrows(Dynamene2,2);
Dynamene2data=sortDynamene2([sortDynamene2(:,2)>=angle],:);
peakDynamene=Dynamene1(:,2).';
csvwrite('Dynamene',peakDynamene);

altKallisto=alt(5841:6205);
decKallisto=dec(5841:6205);
Kallisto1=horzcat(date,altKallisto);
sortKallisto1=sortrows(Kallisto1,2);
Kallisto1data=sortKallisto1([sortKallisto1(:,2)>=angle],:);
Kallisto=sortrows(Kallisto1data,1);
Kallistopeak=max(Kallisto);
Kallistopeakdays=Kallisto([Kallisto(:,2)>=46],:);
Kallisto2=horzcat(date,decKallisto);
sortKallisto2=sortrows(Kallisto2,2);
Kallisto2data=sortKallisto2([sortKallisto2(:,2)>=angle],:);
peakKallisto=Kallisto1(:,2).';
csvwrite('Kallisto',peakKallisto);

altHavnia=alt(6206:6570);
decHavnia=dec(6206:6570);
Havnia1=horzcat(date,altHavnia);
sortHavnia1=sortrows(Havnia1,2);
Havnia1data=sortHavnia1([sortHavnia1(:,2)>=angle],:);
Havnia=sortrows(Havnia1data,1);
Havniapeak=max(Havnia);
Havniapeakdays=Havnia([Havnia(:,2)>=42],:);
Havnia2=horzcat(date,decHavnia);
sortHavnia2=sortrows(Havnia2,2);
Havnia2data=sortHavnia2([sortHavnia2(:,2)>=angle],:);
peakHavnia=Havnia1(:,2).';
csvwrite('Havnia',peakHavnia);

altCorduba=alt(6571:6935);
decCorduba=dec(6571:6935);
Corduba1=horzcat(date,altCorduba);
sortCorduba1=sortrows(Corduba1,2);
Corduba1data=sortCorduba1([sortCorduba1(:,2)>=angle],:);
Corduba=sortrows(Corduba1data,1);
Cordubapeak=max(Corduba);
Cordubapeakdays=Corduba([Corduba(:,2)>=56],:);
Corduba2=horzcat(date,decCorduba);
sortCorduba2=sortrows(Corduba2,2);
Corduba2data=sortCorduba2([sortCorduba2(:,2)>=angle],:);
peakCorduba=Corduba1(:,2).';
csvwrite('Corduba',peakCorduba);

%
%
%
%1 peak day for each top 20 asteroid
peakdays=[23,205,365,1,79,88,0,172,101,53,0,364,246,207,202,0,61,73,192].';
peakdata=horzcat(data(top20asteroidid,1),peakdays(:,1));
altitudepeak=[35,36,37,37,52,36,0,62,67,0,0,37,38,35,47,0,46,42,56].';
peakdata_alt=horzcat(peakdays,altitudepeak);
peak_alt=sortrows(peakdata_alt,1);


%
%
%
%Plot of Top 20 asteroids with peak day versus albedo and magnitude
top20_id_peak_alb_mag=horzcat(data(top20asteroidid,1),peakdata(:,2),data(top20asteroidid,19),data(top20asteroidid,16));
top20_peak_mag_alb=horzcat(peakdata(:,2),data(top20asteroidid,16),data(top20asteroidid,19));





