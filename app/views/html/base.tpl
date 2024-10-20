<!DOCTYPE html>
<html lang="en">
<head>

    <title>
      {% block title %}
        <!-- título de cada página aqui -->
      {% endblock %}
    </title>

    <meta charset="UTF-8">
    <meta name="description" content="">
    <meta name="keywords" content="">
    <meta name="team" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

    <link rel="icon" type="image/x-icon" href="/static/img/favicon.ico" />

    <link rel="stylesheet" type="text/css" href="/static/css/index/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="/static/css/index/owl.carousel.css">
    <link rel="stylesheet" type="text/css" href="/static/css/index/owl.theme.default.min.css">
    <link rel="stylesheet" type="text/css" href="/static/css/index/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="/static/css/index/tooplate-style.css">

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="/static/js/index/custom.js"></script>
    <script src="/static/js/websocket/socket.io.js"></script>

    {% block styles %}
        <!-- estilos específicos de página -->
    {% endblock %}

</head>
<body>

  <!-- PRE LOADER -->
   <section class="preloader">
        <div class="spinner">
             <span class="spinner-rotate"></span>
        </div>
   </section>


   {% block content %}

   <!-- conteúdo de cada página -->

   {% endblock %}

   <!-- FOOTER -->
   <footer id="footer" data-stellar-background-ratio="0.5">
        <div class="container">
             <div class="row">
                  <div class="copyright-text col-md-12 col-sm-12">
                       <div class="col-md-12 col-sm-12">
                         <p>Copyright &copy; 2024 Meta Bloom - Design:
                       <a rel="nofollow" href="http://tooplate.com">Tooplate</a></p>
                       </div>
                  </div>
             </div>
        </div>
    </footer>

    <!-- SCRIPTS -->
    <script src="/static/js/index/jquery.min.js"></script>
    <script src="/static/js/index/bootstrap.min.js"></script>
    <script src="/static/js/index/owl.carousel.min.js"></script>
    <script src="/static/js/index/jquery.stellar.min.js"></script>
    <script src="/static/js/index/custom.js"></script>
</body>
</html>
