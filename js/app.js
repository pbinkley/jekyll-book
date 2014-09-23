/** Your custom JavaScript goes here. **/
(function($) {
  $(function() {

    // Handle the video modal.
    $('#video-modal').on('shown.bs.modal', function(event) {

      // Load the video.
      $('.modal-body .embed-responsive', this).append($('#video-template').html());
    }).on('hidden.bs.modal', function(event) {

      // Remove the video
      $('.modal-body .embed-responsive iframe', this).remove();
    });
  });
})(jQuery);
