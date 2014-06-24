
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
               
          }
    },
    
    saveImageToPhone : function (url, success, error) {
        var canvas, context, imageDataUrl, imageData;
        var img = new Image();
        img.onload = function() {
            canvas = document.createElement('canvas');
            canvas.width = img.width;
            canvas.height = img.height;
            context = canvas.getContext('2d');
            context.drawImage(img, 0, 0);
            try {
                imageDataUrl = canvas.toDataURL('image/jpeg', 1.0);
                imageData = imageDataUrl.replace(/data:image\/jpeg;base64,/, '');
                cordova.exec(
                             success,
                             error,
                             'Canvas2ImagePlugin',
                             'saveImageDataToLibrary',
                             [imageData]
                             );
            }
            catch(e) {
                error(e.message);
            }
        };
        try {
            img.src = url;
        }
        catch(e) {
            error(e.message);
        }
    }
   

    
  
}

