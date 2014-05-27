$ ->
  $('#contact_us').validate
    rules:
      'contact[email]':
        required: yes
        email: yes
      'contact[name]':
        required: yes
      'contact[message]':
        required: yes
      'contact[subject]':
        required: yes
