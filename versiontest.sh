#|/bin/bash
cd $1
if ! [ -d $2 ] 
then
    echo "Creating folder $2..."
    mkdir $2
fi
for i in $(seq 1 $5);
do
  if [ -d "$2/$i" ] 
  then
      echo "Deleting folder $2/$i..."
      rm -rf $2/$i/
  echo "Creating folder $2/$i..."
  mkdir $2/$i    
  fi
    docker run -it -v "$1/$2/$i:/home/alex/tmp/test_reports/" -v "$4/.gradle/wrapper:/home/alex/.gradle/wrapper" -v "$4/.gradle/caches:/home/alex/.gradle/caches"  elastic/$3 /bin/bash -c "git checkout tags/$2 -b $2 &&\
    ./gradlew --stop && ./gradlew :server:test --tests org.elasticsearch.search.aggregations.bucket.missing.* --build-cache &&\
    cp -r /home/alex/elasticsearch/server/build/reports/tests/test /home/alex/tmp/test_reports"
done
