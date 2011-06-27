var RequestedStudent = (function() {

  //
  // private data, methods
  //
  var index = 0;

  // Output html:
  // 
  // <div class="input string required">
  //   <label class="string required" for="account_request_requested_students_attributes_0_first_name">
  //     <abbr title="required">*</abbr>
  //     First name
  //   </label>
  //   <input class="string required" 
  //       id="account_request_requested_students_attributes_0_first_name" 
  //       maxlength="255" 
  //       name="account_request[requested_students_attributes][0][first_name]" 
  //       required="required" size="50" type="text" />
  // </div>
  function nameField(idx, part) {
    var id_attr = 'account_request_requested_students_attributes_' + idx + '_' +
        part + '_name';
    var $div = $('<div>', {
      class: 'input string required'
    });
    var $label = $('<label>', {
      class: 'string required',
      for: id_attr,
    });
    var $abbr = $('<abbr>', {
      title: 'required'
    });
    $abbr.append('*');
    $label.append($abbr);
    $label.append(capitalizeFirstLetter(part) + ' name');
    $div.append($label);
    var $input = $('<input>', {
      class: 'string required',
      id: id_attr,
      maxlength: '255',
      name: 'account_request[requested_students_attributes][' + idx + 
          '][' + part + '_name]',
      size: '50',
      type: 'text'
    });
    $div.append($input);
    return wrapped($div);
  }

  // Output html:
  //
  // <div class="input select required">
  //   <label class="select required" for="account_request_requested_students_attributes_0_grade">
  //     <abbr title="required">*</abbr>
  //     Grade
  //   </label>
  //   <select class="select required" 
  //       id="account_request_requested_students_attributes_0_grade" 
  //       name="account_request[requested_students_attributes][0][grade]"><option value=""></option>
  //     <option value="K">K</option>
  //     <option value="1">1</option>
  //     <option value="2">2</option>
  //     <option value="3">3</option>
  //     <option value="4">4</option>
  //     <option value="5">5</option>
  //     <option value="6">6</option>
  //     <option value="7">7</option>
  //     <option value="8">8</option>
  //     <option value="9">9</option>
  //     <option value="10">10</option>
  //     <option value="11">11</option>
  //     <option value="12">12</option>
  //   </select>
  // </div>
  function gradeField(idx) {
    var $div = $('<div>', {
      class: 'input select required'
    });
    var $label = $('<label>', {
      class: 'string required',
      for: 'account_request_requested_students_attributes_' + idx + '_grade'
    });
    var $abbr = $('<abbr>', {
      title: 'required'
    });
    $abbr.append('*');
    $label.append($abbr);
    $label.append('Grade');
    $div.append($label);
    var $select = $('<select>', {
      class: 'select required',
      id: 'account_request_requested_students_attributes_' + idx + '_grade',
      name: 'account_request[requested_students_attributes][' + idx + '][grade]'
    });
    var optionValues = ['', 'K', '1', '2', '3', '4', '5', '6', '7', '8', '9', 
        '10', '11', '12'];
    for(var i = 0; i < optionValues.length; i++) {
      var $option = $('<option>', {
        value: optionValues[i]
      });
      $option.append(optionValues[i]);
      $select.append($option);
    }
    $div.append($select);
    return wrapped($div);
  }

  function capitalizeFirstLetter(s) {
    return s.charAt(0).toUpperCase() + s.slice(1);
  }
  
  function wrapped($elem) {
    var $container = $('<div>', {});
    $container.append($elem);
    return $container.html();
  }

  //
  // public interface
  // 
  return {
    addFields: function () {
      index++;
      var html = '<hr />';
      html += nameField(index, 'first');
      html += nameField(index, 'last');
      html += gradeField(index);
      $('fieldset#students').append(html);
    },
  };
})();

$(document).ready(function() {
  $('a#add_student').click(function(e) {
    e.preventDefault();
    RequestedStudent.addFields();
  });
});

