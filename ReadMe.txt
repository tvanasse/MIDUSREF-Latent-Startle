MidusCorrAndZygo.m and StartleScript.m are the two most novel/useful scripts here. Other scripts are mostly just nitty-gritty sub-commands. See descriptions below. 


acqStartle	.m	Processes EBR data. Study specific calls, so needed to add Midusref to the script.
createMidusACQcorrugator	.m		Processes Corr data. Had to adapt from Midus to Midusref.
createMidusACQzygo	.m	Processes Zygo data exactly like Corr data. Just switched channels/names of createMidusACQcorrugator.m
MidusCorrAndZygo	.m	***Streamlined, userfriendly script to process both Corrugator AND Zygomaticus from Midusref. Simply run this and it will ask for subject number(s) (with or without leading zeros for non-three digit numbers).***
processMIDUSProbe	.m	Pulls out DIN probes & interprets them
processMIDUSStartle	.m	Called by acqStartle.m to do the nitty gritty of processing EBR raw data.
readACQFile.	.m	Updated by Karthik to work with new version of Acqknowledge (had header issues with new acq files + original readACQFile.m
setupacqStartle_Keck	.m	Just adds correct paths
StartleScript	.m	***Streamlined, userfriendly script to process AND open EBR data from Midusref, by running this & inputting subject number(s). Then it processes that/those sub(s). It then asks if you want to open a file for viewing (y/n). If y, it asks which sub. Then gives list of that sub's processed files, and you select one.***
tdfwrite	.m	Just a new matlab command; complimentary to tdfread (writes struct variable to txt)
