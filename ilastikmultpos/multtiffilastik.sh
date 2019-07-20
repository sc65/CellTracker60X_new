#!/bin/bash
# ilastik segmentation output to peaks: input- multiple time points, multichannel, multitiff files.
#ndir: new directory where segmentation results are saved
#projectpath: path corresponding to ilastik project that was usecd to train a sample dataset
#savepath: path corresponding to ilastik output export directory
#segchannel: channel used for segmenting images
#samplepath: path corresponding to sample images that are yet to be segmented - serves as an input to the matlab function
#files: image files in the samplepath that are to be segmented 


i=0
num=1

ndir=/Users/warmflash2/Desktop/train_ilastik/pxlseg/

projectpath=/Users/warmflash2/Desktop/train_ilastik/multitiffpxlclass_2.ilp

savepath=/Users/warmflash2/Desktop/train_ilastik/seglabel.h5

segchannel=1

mkdir $ndir

samplepath=/Users/warmflash2/Desktop/train_ilastik/multtif/;

files=/Users/warmflash2/Desktop/train_ilastik/multtif/*

for f in $files
do
./ilastik-1.1.6-OSX.app/Contents/MacOS/python ilastik-1.1.6-OSX.app/Contents/Resources/ilastik.py --headless  --project=$projectpath $f

i=$((i+num))

scp $savepath ${ndir}fileseg${i}.h5

echo $f $i
done



export PATH=/Applications/MATLAB_R2015a.app/bin:$PATH


matlab -nodesktop -nosplash -r ilastikout2peaks\(\'$ndir\',\'$samplepath\',$segchannel\); 

exit;



