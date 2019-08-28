
$.fn.DataTable.ext.pager.numbers_length = 3;

$(document).ready(function() {

  $().counterUp && $("[data-counter='counterup']").counterUp({
    delay: 10,
    time: 1e3
  });

  /*** Main image  ***/
  if (window.innerWidth > 768) {
    $('#description-img').css('height', $('#coupon-form').height());
  }

  /*** Input images ***/
  var fileInputOpts = { language: "es", allowedFileTypes: ["image"], showUpload: false};
  $(".image-upload-field").fileinput(fileInputOpts);

  /*** Message alert ***/
  if($.trim($('.app-popup-alert').html())){
    $('.app-popup-alert').fadeIn('slow');
    setTimeout(function(){
      $('.app-popup-alert').fadeOut();
    }, 5000);
  }

  /*** Datatable ***/
  var optionsDatatable = {
    "pagingType": "full_numbers",
    "lengthMenu": [[3, 50, 250, 500, -1], [3, 50, 250, 500, "All"]],
    "pageLength": 3,
    "order": [[0, "desc"]],
    "scrollX": true,

    language: {
      processing:     "Procesando...",
      search:         "Buscar",
      lengthMenu:     "_MENU_",
      info:           "_START_ - _END_ de _TOTAL_ registros",
      infoEmpty:      "0 registros",
      infoFiltered:   "(filtrado de un total de _MAX_ registros)",
      infoPostFix:    "..?!",
      loadingRecords: "Cargando...",
      zeroRecords:    "No se encontraron resultados",
      emptyTable:     "Ningún dato disponible en esta tabla",

      paginate: {
        first:      "<<",
        previous:   "<",
        next:       ">",
        last:       ">>"
      },

      aria: {
        sortAscending:  ": Activar para ordenar la columna de manera ascendente",
        sortDescending: ": Activar para ordenar la columna de manera descendente"
      }

    }
  }

  $(".datatable-plugin").DataTable(optionsDatatable);

  $('.dataTables_filter').css('margin-top', 0);
  $('.dataTables_length').parent().addClass('col-xs-4');
  $('.dataTables_filter').parent().addClass('col-xs-8');
});

function showLogin() {
  $('#form-login').css('display', 'inline-block');
  $('#cat').css('display', 'none');
}
