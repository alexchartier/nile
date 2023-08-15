mov='mov.mp4'
rm -rf tmp/
mkdir tmp
a=1
for i in $1/*.png; do
  j=`basename $i`
  new=$(printf "%04d$j" "$a") #04 pad to length of 4
  cp -i -- "$i" "tmp/$new"
  let a=a+1
done

ffmpeg  -f image2 -r 9 -pattern_type glob -i 'tmp/*.png' -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2"  -pix_fmt yuv420p  $mov
echo "Saved movie to $mov"
rm -rf tmp/

