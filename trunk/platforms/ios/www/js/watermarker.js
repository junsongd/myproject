
var watermarker = {
    
    app_width : "",
    app_height: "",
    
    
    init : function ()
    {
        // caculator the width  for different screen size
        watermarker.app_width  =  $(document).width();
        watermarker.app_height =  $(document).height();
        
        $("#btn_select_photo").click(function(){watermarker.selectPhotoButtonClicked();});
    },
    
    // click select photo function
    selectPhotoButtonClicked : function ()
    {
       
        window.imagePicker.getPictures(
                                       function(results) {
                                       
                                       watermarker.displayImageList(results);
                                       wmark.init({
                                                  /* config goes here */
                                                  "position": "bottom-right", // default "bottom-right"
                                                  "opacity": 70, // default 50
                                                  "className": "watermark", // default "watermark"
                                                  "path": "https://dl.dropboxusercontent.com/u/74389544/watermarkjs/demos/img/qr.png"
                                                  });
                                       }, function (error) {
                                       console.log('Error: ' + error);
                                       }, {
                                       maximumImagesCount: 10,
                                       width: 320
                                       }
                                       );
        
    },
    displayImageList : function(imageList)
    {
        
        
          $('#imagelist').html(" ");
           for (var i = 0; i < imageList.length; i++) {
            var imgUrl = imageList [i];
               
          $('#imagelist').prepend('<li class= "imageItem "><img class ="image watermark" src ='+ imgUrl+'></img></li>');
               
                // watermarker.loadCanvas(imgUrl);
          }
        $( ".watermark" ).each(function( index ) {
                               var image = this.src;
                             watermarker.loadCanvas(image);

                               
                        });
        
    },
    loadCanvas : function loadCanvas(dataURL) {
        var canvas = document.getElementById('myCanvas');
        var context = canvas.getContext('2d');
        var self = this;
        // load image from data url
        var imageObj = new Image ();
         imageObj.src = dataURL;
         imageObj.onload = function() {
            context.drawImage(this, 0, 0,100,100);
           
        };
        
        watermarker.saveImages();
      
    },
    
    saveImages :function ()
    {
        window.canvas2ImagePlugin.saveImageDataToLibrary(
                                                         function(msg){
                                                         console.log(msg);
                                                         },
                                                         function(err){
                                                         console.log(err);
                                                         },
                                                         document.getElementById('myCanvas')
                                                         );
    
    
    
    }
    
  
}

