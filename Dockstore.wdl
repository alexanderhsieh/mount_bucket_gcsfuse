## Copyright Broad Institute, 2020
## TESTED: 
## Versions of other tools on this image at the time of testing:
##
## LICENSING : This script is released under the WDL source code license (BSD-3) (see LICENSE in https://github.com/broadinstitute/wdl). 
## Note however that the programs it calls may be subject to different licenses. Users are responsible for checking that they are authorized to run all programs before running this script. 
## Please see the docker for detailed licensing information pertaining to the included programs.
##


###########################################################################
#WORKFLOW DEFINITION
###########################################################################
workflow mount_bucket {
  
  String google_bucket_path
  
  meta{
    author: "Alex Hsieh"
    email: "ahsieh@broadinstitute.org"
  }

  call run_gcsfuse {
    input:
    bucket_path = google_bucket_path

  }

  output {
    File file_list = run_gcsfuse.out
      
  }

}


###########################################################################
#Task Definitions
###########################################################################

task run_gcsfuse {
  String bucket_path

  command{
    # set up credentials for Cloud Storage FUSE
    gcloud auth application-default login

    # create a directory
    mkdir ~/tmp/bucket

    # use Cloud Storage FUSE to mount the bucket
    gcsfuse ${bucket_path} ~/tmp/bucket

    # list contents for inspection
    ls -trhl ~/tmp/bucket > file_listing.txt

  }

  runtime {
    docker: "mwalker174/sv-pipeline:mw-00c-stitch-65060a1" 
    preemptible: 3
    maxRetries: 3
  }

  output {
    File out = "file_listing.txt"

  }
}


