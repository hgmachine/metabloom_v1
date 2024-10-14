{% extends "base.tpl" %}

{% block title %} Meta Bloom Home {% endblock %}

{% block styles %} {% endblock %}

{% block content %}

<!-- MENU -->
<section class="navbar custom-navbar navbar-fixed-top" role="navigation">
     <div class="container">

          <div class="navbar-header">
               <button class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="icon icon-bar"></span>
                    <span class="icon icon-bar"></span>
                    <span class="icon icon-bar"></span>
               </button>

               <!-- lOGO TEXT HERE -->
               <a href="/" class="navbar-brand">Meta Bloom</a>
          </div>

          <!-- MENU LINKS -->
          <div class="collapse navbar-collapse">
               <ul class="nav navbar-nav">
                    <li><a href="#home" class="smoothScroll">Topo</a></li>
                    <li><a href="#feature" class="smoothScroll">Sobre</a></li>
               </ul>
          </div>

     </div>
</section>


<!-- FEATURE -->
<section id="home" data-stellar-background-ratio="0.5">
     <div class="overlay"></div>
     <div class="container">
          <div class="row">
               <div class="col-md-offset-3 col-md-6 col-sm-12">
                    <div class="home-info">
                         <h3>Meta Bloom: prática elaborada dos níveis cognitivos</h3>
                         <h1>Ajudando pessoas a realizar os seus sonhos</h1>
                         <form action="/index" method="post" class="form-inline">
                              <div class="form-group">
                                   <input type="text" name="username" class="form-control" placeholder="Seu nome de usuário" required="">
                              </div>
                              <div class="form-group">
                                   <input type="password" name="password" class="form-control" placeholder="Sua senha (6 digitos) " required="">
                              </div>
                              <button type="submit" class="btn btn-primary">Logar</button>
                         </form>
                    </div>
               </div>
          </div>
     </div>
</section>

<!-- FEATURE -->
<section id="feature" data-stellar-background-ratio="0.5">
     <div class="container">
          <div class="row">

               <div class="col-md-12 col-sm-12">
                    <div class="section-title">
                         <h1>Recursos da Meta Bloom</h1>
                    </div>
               </div>

               <div class="col-md-6 col-sm-6">
                    <ul class="nav nav-tabs" role="tablist">
                         <li class="active"><a href="#tab01" aria-controls="tab01" role="tab" data-toggle="tab">Meta</a></li>

                         <li><a href="#tab02" aria-controls="tab02" role="tab" data-toggle="tab">Bloom</a></li>

                         <li><a href="#tab03" aria-controls="tab03" role="tab" data-toggle="tab">Lemas</a></li>
                    </ul>

                    <div class="tab-content">

                         <div class="tab-pane active" id="tab01" role="tabpanel">
                              <div class="tab-pane-item">
                                   <h2>Estrutura</h2>
                                   <p>Na Aprendizagem por Competências, as atividades são estruturadas de forma a desenvolver habilidades práticas e aplicáveis em níveis graduais. Isso permite que os estudantes evoluam progressivamente, adquirindo e controlando competências que os capacitam a enfrentar desafios reais de forma eficiente e autônoma.</p>
                              </div>
                              <div class="tab-pane-item">
                                   <h2>Na Meta Bloom</h2>
                                   <p>A Meta Bloom adapta a Aprendizagem por Competências com foco na estruturação de resultados alcançáveis, promovendo a automotivação e a eficiência do estudo. Assim, o estudante assume o papel de protagonista no processo de aprendizagem, que se desenrola em etapas cuidadosamente planejadas para desenvolver cada habilidade necessária de forma progressiva e eficaz.</p>
                              </div>
                         </div>

                         <div class="tab-pane" id="tab02" role="tabpanel">
                              <div class="tab-pane-item">
                                   <h2>Estrutura</h2>
                                   <p>A Taxonomia de Bloom é um modelo que sugere um processo de aprendizado em níveis hierárquicos, partindo de habilidades mais simples como lembrar e compreender até as mais complexas, como avaliar e criar. Essa estrutura auxilia no planejamento educacional, ajudando a definir objetivos claros para o desenvolvimento cognitivo dos estudantes.</p>
                              </div>
                              <div class="tab-pane-item">
                                  <h2>Na Meta Bloom</h2>
                                  <p>A Meta Bloom adapta a Taxonomia de Bloom para focar no desenvolvimento psicomotor, organizando os avanços práticos em níveis graduais. As atividades são estruturadas para que os estudantes evoluam de forma progressiva, preparando-se de maneira sistemática para aprimorar o controle de suas habilidades manuais e mentais.</p>
                              </div>
                         </div>

                         <div class="tab-pane" id="tab03" role="tabpanel">
                              <div class="tab-pane-item">
                                   <h2>Faça pouco, mas faça certo</h2>
                                   <p>O volume de tarefas não dominadas dificulta o progresso de um aprendizado. Fazendo de pouco em pouco temos a chance de focar na qualidade de cada pequeno avanço, sem quaisquer aproximações que possam prejudicar no longo prazo.</p>
                              </div>
                              <div class="tab-pane-item">
                                   <h2>Faça lentamente, mas faça de maneira precisa</h2>
                                   <p>A velocidade de resposta, seja muscular ou cognitiva, depende de um controle maior sobre o que se pretende realizar. Neste sentido, pode ser mais difícil a realização de um aprendizado em um nível de dificuldade alterado além de nossa
                                     capacidade de administração daquele conhecimento. Por este motivo, a velocidade mais lenta, de pensamento e prática, nos ajuda a nos organizar melhor e evoluir para condições mais automáticas.</p>
                              </div>
                              <div class="tab-pane-item">
                                   <h2>Faça de uma forma simples, mas elegante</h2>
                                   <p>Menos é mais! Quando organizado de uma forma clara e simplificada, um aprendizado pode evoluir mais rapidamente, com efiácia e elegância. Isto ocorre devido à menor quantidade de
                                   elementos novos capazes de gerar preocupações ou esforços adicionais.</p>
                              </div>
                              <div class="tab-pane-item">
                                   <h2>Priorize o resultado e não o tempo de estudo</h2>
                                   <p>Não adianta trabalhar de forma desbalanceada em relação à aquisição de conhecimentos teóricos e práticos. Estas duas área de conhecimento devem funcionar como as asas de um pássaro, de maneira conjunta, não importando o tamanho ou a força. O que mais vale para aprender
                                   é o equilíbro entre estas duas aquisições e a constância sobre nos trabalhos.</p>
                              </div>
                              <div class="tab-pane-item">
                                   <h2>Viva o seu sonho todos os dias</h2>
                                   <p>Sem prazer não há empenho total. É preciso estruturar um sonho em metas atingíveis, para que o mesmo saia de nossas cabeças para o papel, para o computador e, depois, para a vida. Existem sonhos de pequeno, médio e longo prazo, mas em qualquer situação é possível
                                     experimentar resultados que podem nos dar a sensação de estarmos fazendo e acontecendo, de uma maneira real.</p>
                              </div>
                         </div>
                    </div>
               </div>

               <div class="col-md-6 col-sm-6">
                    <div class="feature-image">
                         <img src="{{'/static/img/index/feature-mockup.png'}}" class="img-responsive" alt="Thin Laptop">
                    </div>
               </div>

          </div>
     </div>
</section>


<!-- ABOUT
<section id="about" data-stellar-background-ratio="0.5">
     <div class="container">
          <div class="row">

               <div class="col-md-offset-3 col-md-6 col-sm-12">
                    <div class="section-title">
                         <h1>Equipe Meta Bloom</h1>
                    </div>
               </div>

               <div class="col-md-4 col-sm-4">
                    <div class="team-thumb">
                         <img src="{{'/static/img/index/team-image1.jpg'}}" class="img-responsive" alt="Andrew Orange">
                         <div class="team-info team-thumb-up">
                              <h2>Henrique Moura</h2>
                              <small>Idealizador e Professor</small>
                              <p>Lorem ipsum dolor sit amet, consectetur adipisicing eiusmod tempor incididunt ut labore et dolore magna.</p>
                         </div>
                    </div>
               </div>

               <div class="col-md-4 col-sm-4">
                    <div class="team-thumb">
                         <div class="team-info team-thumb-down">
                              <h2>Monitores</h2>
                              <small>Sala de aula e redes sociais</small>
                              <p>Lorem ipsum dolor sit amet, consectetur adipisicing eiusmod tempor incididunt ut labore et dolore magna.</p>
                         </div>
                         <img src="{{'/static/img/index/team-image3.jpg'}}" class="img-responsive" alt="Catherine Soft">
                    </div>
               </div>

               <div class="col-md-4 col-sm-4">
                    <div class="team-thumb">
                         <img src="{{'/static/img/index/team-image2.jpg'}}" class="img-responsive" alt="Jack Wilson">
                         <div class="team-info team-thumb-up">
                              <h2>Vanessa Lemos</h2>
                              <small>CEO / Mantenedora</small>
                              <p>Lorem ipsum dolor sit amet, consectetur adipisicing eiusmod tempor incididunt ut labore et dolore magna.</p>
                         </div>
                    </div>
               </div>

          </div>
     </div>
</section>

TESTIMONIAL
<section id="testimonial" data-stellar-background-ratio="0.5">
     <div class="container">
          <div class="row">
               <div class="col-md-6 col-sm-12">
                    <div class="testimonial-image"></div>
               </div>
               <div class="col-md-6 col-sm-12">
                    <div class="testimonial-info">
                         <div class="section-title">
                              <h1>O que as pessoas dizem</h1>
                         </div>
                         <div class="owl-carousel owl-theme">
                              <div class="item">
                                   <h3>Vestibulum tempor facilisis efficitur. Sed nec nisi sit amet nibh pellentesque elementum. In viverra ipsum ornare sapien rhoncus ullamcorper.</h3>
                                   <div class="testimonial-item">
                                        <img src="{{'/static/img/index/tst-image1.jpg'}}" class="img-responsive" alt="Michael">
                                        <h4>Michael</h4>
                                   </div>
                              </div>
                              <div class="item">
                                   <h3>Donec pretium tristique elit eget sodales. Pellentesque posuere, nunc id interdum venenatis, leo odio cursus sapien, ac malesuada nisl libero eget urna.</h3>
                                   <div class="testimonial-item">
                                        <img src="{{'/static/img/index/tst-image2.jpg'}}" class="img-responsive" alt="Sofia">
                                        <h4>Sofia</h4>
                                   </div>
                              </div>
                              <div class="item">
                                   <h3>Lorem ipsum dolor sit amet, consectetur adipisicing eiusmod tempor incididunt ut labore et dolore magna.</h3>
                                   <div class="testimonial-item">
                                        <img src="{{'/static/img/index/tst-image3.jpg'}}" class="img-responsive" alt="Monica">
                                        <h4>Monica</h4>
                                   </div>
                              </div>
                         </div>
                    </div>
               </div>
          </div>
     </div>
</section>
-->

<!-- PRICING
<section id="pricing" data-stellar-background-ratio="0.5">
     <div class="container">
          <div class="row">

               <div class="col-md-12 col-sm-12">
                    <div class="section-title">
                         <h1>Choose any plan</h1>
                    </div>
               </div>

               <div class="col-md-4 col-sm-6">
                    <div class="pricing-thumb">
                        <div class="pricing-title">
                             <h2>Student</h2>
                        </div>
                        <div class="pricing-info">
                              <p>20 Responsive Designs</p>
                              <p>10 Dashboards</p>
                              <p>1 TB Storage</p>
                              <p>6 TB Bandwidth</p>
                              <p>24-hour Support</p>
                        </div>
                        <div class="pricing-bottom">
                              <span class="pricing-dollar">$200/mo</span>
                              <a href="#" class="section-btn pricing-btn">Register now</a>
                        </div>
                    </div>
               </div>

               <div class="col-md-4 col-sm-6">
                    <div class="pricing-thumb">
                        <div class="pricing-title">
                             <h2>Business</h2>
                        </div>
                        <div class="pricing-info">
                              <p>50 Responsive Designs</p>
                              <p>30 Dashboards</p>
                              <p>2 TB Storage</p>
                              <p>12 TB Bandwidth</p>
                              <p>15-minute Support</p>
                        </div>
                        <div class="pricing-bottom">
                              <span class="pricing-dollar">$350/mo</span>
                              <a href="#" class="section-btn pricing-btn">Register now</a>
                        </div>
                    </div>
               </div>

               <div class="col-md-4 col-sm-6">
                    <div class="pricing-thumb">
                        <div class="pricing-title">
                             <h2>Professional</h2>
                        </div>
                        <div class="pricing-info">
                              <p>100 Responsive Designs</p>
                              <p>60 Dashboards</p>
                              <p>5 TB Storage</p>
                              <p>25 TB Bandwidth</p>
                              <p>1-minute Support</p>
                        </div>
                        <div class="pricing-bottom">
                              <span class="pricing-dollar">$550/mo</span>
                              <a href="#" class="section-btn pricing-btn">Register now</a>
                        </div>
                    </div>
               </div>

          </div>
     </div>
</section>
-->

<!-- CONTACT
<section id="contact" data-stellar-background-ratio="0.5">
     <div class="container">
          <div class="row">

               <div class="col-md-offset-1 col-md-10 col-sm-12">
                    <form id="contact-form" role="form" action="" method="post">
                         <div class="section-title">
                              <h1>Envie aqui a sua mensagem </h1>
                         </div>

                         <div class="col-md-4 col-sm-4">
                              <input type="text" class="form-control" placeholder="Full name" name="name" required="">
                         </div>
                         <div class="col-md-4 col-sm-4">
                              <input type="email" class="form-control" placeholder="Email address" name="email" required="">
                         </div>
                         <div class="col-md-4 col-sm-4">
                              <input type="submit" class="form-control" name="send message" value="Send Message">
                         </div>
                         <div class="col-md-12 col-sm-12">
                              <textarea class="form-control" rows="8" placeholder="Your message" name="message" required=""></textarea>
                         </div>
                    </form>
               </div>

          </div>
     </div>
</section>
-->

{% endblock %}
