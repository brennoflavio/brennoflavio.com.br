---
title: "Como resolvi o problema de Privacidade no meu celular"
date: 2022-01-03T00:02:04-03:00
draft: false
type: post
---

Após 10 anos usando Ubuntu e alguns derivados como sistema de trabalho e diversão principal, eu comecei a me sentir incomodado com questões de privacidade, especialmente com meu telefone.

A dependência de serviços proprietários e a forma como empresas abraçaram o modelo de negócios SAAS e freemium, em que parte do produto são seus dados é de certa forma perturbadora.

Ao usar um serviço proprietário hoje, normalmente você está concordando em ceder seus dados para Google e Facebook, mesmo que não tenha conta ou o serviço não tenha relação com essas empresas, normalmente sendo impossível usar o serviço em questão sem ceder os dados.

Por outro lado, faltam guias de como reduzir a dependência desses serviços e utilizar serviços que te respeitem como consumidor, especialmente em português.

Este guia irá tentar apresentar conceitos, configurações, e alternativas, para tentar conseguir manter um balanço entre um celular usável e privado, focado no público brasileiro.

# Uma nota sobre privacidade

Não existe privacidade com software proprietário. Esse conceito é importante de se entender, pois idealmente, nós deveríamos utilizar apenas software de código aberto, auditado, livre de rastreadores, e que não mandam seus dados para serviços de tereceiros. Ainda assim é impossível alcançar isso hoje sem abrir mão do conforto de usar seu telefone.

Muito provavelmente seu celular possui blobs proprietários no Kernel, e você depende de apps de comunicação, bancos, e outros que são proprietários.

Isso não é desculpa para reduzir a dependência de corporações como Google e Facebook, e reduzir a quantidade enviada de dados para eles. Este guia tenta apresentar um balanço entre um celular usável e com o máximo de software open source possível. Esse balanço sempre pode ser melhorado, fique à vontade para contribuir.

# Uma nota sobre usuários de IPhone

Não existe privacidade no mundo da Apple. Como falei antes, se não conseguimos auditar o sofware, não há garantias de que ele é privado. É conhecido que a Apple também coleta seus dados apesar de eles anunciarem que não. Basta ler os termos de uso de qualquer serviço deles.

Neste guia eu assumo que você tem um aparelho Android, onde de fato temos ferramentas para reduzir a quantidade de dados que você entrega para as grandes corporações.

Se você está pensando em adquirir um aparelho Android, escolha um compatível com o [Lineage OS](https://download.lineageos.org/). Este guia parte do pressuposto que você vai conseguir instalar esse sistema, que é uma das melhores implementações do Android Open Source Project (AOSP), sem os blobs proprietários do fabricante que você escolheu. Pessoalmente, uso um Pocophone F1.

# Configurando seu servidor

Você provavelmente usa diversos serviços do Google. Drive, Docs, Calendar, entre outros. Nossa meta é deletar sua conta do Google, e para isso, você vai precisar de alternativas.

O melhor substitudo dos serviços do Google no servidor é o Nextcloud. Ele é uma nuvem completa, que oferece serviços de armazenamento, calendário, email, tarefas, múltiplos usuários, entre outros.

Abaixo eu irei, em linhas gerais, explicar como eu configurei meu servidor para ter controle dos dados que não estão no meu celular. Se tiver dificuldade em alguma parte, sinta-se a vontade para entrar em contato no meu [email](mailto:contato@brennoflavio.com.br).

Primeiramente, você precisa de um lugar para hospedar seus dados. Como no futuro você vai integrar o Nextcloud com seu telefone, ele tem que estar exposto para a internet.

Durante minha pesquisa, para a quantidade de dados que eu tinha no Google Drive (cerca de 40GB), achei proibitivo o valor de VM's na Amazon, Google Cloud e Azure. Então eu fiz o seguinte setup:

1. Raspberry Pi onde eu hospedo meu Nextcloud, na minha rede privada
2. Uma VM no tier grátis da AWS para expor o servidor através de um proxy reverso, no caso o [FRP](https://github.com/fatedier/frp)

# Configurando o Raspberry Pi

Primeiramente, adquira um Raspberry Pi. Eu uso o 4, com 2GB de Ram. Comprei usado na OLX. Você também precisa de um bom cartão SD. Eu uso um de 64GB, classe 10.

Baixe o [Raspberry Pi Installer](https://www.raspberrypi.org/downloads.../) para seu sistema, e conecte o cartão SD no seu computador.

No programa, escolha a versão do Raspberry Pi OS Lite (sem interface gráfica) e siga as instruções para baixar e isntalar a imagem no cartão SD. Existem dezenas de guias na internet com mais detalhes, como o foco é o Android, não irei extender.

Após finalizar o processo, abra um gerenciador de partições (uso o GParted) e garanta que todo o espaço do seu cartão está sendo utilizado pelo Raspberry.

Vá na partição de boot, dentro do cartão SD, e crie um arquivo vazio chamado `ssh`. Isso irá habilitar acesso remoto no seu Raspi.

Logue nele (sugiro conectar um monitor e teclado nessa fase) e [garanta que o seu Raspberry Pi tem IP Fixo com esse guia](https://raspberrypi-guide.github.io/networking/set-up-static-ip-address).

Além disso, crie o arquivo `$HOME/.ssh/authorized_keys` e cole sua chave SSH pública lá dentro.

Agora você pode instalar ele em algum lugar apropriado, de preferência com internet cabeada, e controlar ele do seu computador principal.

# Instalando o Nextcloud

Existem diversos guias que detalham esta parte. No geral, você irá instalar um servidor Apache, o PHP e suas dependências, e baixar os arquivos do Nextcloud no seu servidor. [Recomendo este guia para instalação](https://raspberrytips.com/install-nextcloud-raspberry-pi/).

Preste atenção, pois o o guia acima usa uma versão desatualizada do Nextcloud. Quando for baixar o zip, baixe a mais recente do site. Além disso, siga o método alternativo, pois você está usando o Raspberry Pi OS puro, não a versão com o Nextcloud pré instalado.

No final do processo, você deve conseguir abrir seu servidor Nextcloud na sua rede local pelo IP do Raspberry

# Expondo o Raspberry para a internet

Você irá precisar de uma conta na AWS e de um domínio. Vá no registro.br e compre o domínio de sua preferência. Na AWS, crie uma VM (eles chamam de EC2), no free tier, com configurações padrão.

Esta VM irá comunicar com seu Raspberry através de um proxy reverso, o [FRP](https://github.com/fatedier/frp). Baixe e instale o FRP do github, e siga o guia para habilitar o acesso SSH remoto. Não se esqueça de abrir as portas da sua VM no painel da AWS.

Com tudo funcionando, você pode remover este acesso, pois é inseguro.

No seu raspberry, você quer mapear o seu servidor apache em alguma porta remota na sua VM. Por exemplo, você pode mapear a porta 80 com a porta 8080 na VM com a seguinte configuração no seu arquivo `frpc.ini`:

```
[web]
type = tcp
local_ip = 127.0.0.1
local_port = 80
remote_port = 8080
```

Agora seu Nextcloud está exposto para a internet, mas sem segurança alguma. Vamos habilitar HTTPS nele.

# Habilitando HTTPS no Nextcloud

Instale o Nginx e o Certbot no seu servidor. No Ubuntu:
```
sudo apt install nginx
sudo snap install certbot
```

[Siga as instruções oficiais para configurar o Nginx na porta 443, com seu domínio, possibilitando o acesso a sua instância por https](https://certbot.eff.org/instructions)

Você agora terá que alterar a configuração do NGINX para redirecionar todo o tráfego na porta 443 para o NextCloud. Crie uma diretriz `upstream` e use a diretriz `proxy_pass` para redirecionar o tráfego, como no exemplo abaixo. Novamente, a internet é sua aliada para conseguir rodar isso propriamente.

Nesta parte você provavelmente vai receber um erro do Nextcloud que o domínio não é confiável. Dentro da pasta onde você instalou o Nextcloud, edite o arquivo `config/config.php`, adicionando seu domínio como confiável, conforme exemplo:

```
'trusted_domains' => 
  array (
    0 => '<ip privado do raspi>',
    1 => '<seudominio.com.br>',
  )
'overwrite.cli.url' => 'https://seudominio.com.br'
```

Após as edições, salve, reinicie o apache, e seu Nextcloud deve estar funcioando normalmente.

# Provedor de Email

Em um mundo ideal, nós deveríamos conseguir configurar nosso próprio servidor de email. Na prática, todos seus emails vão cair no spam, e seu servidor vai ser atacado por bots e emails automáticos.

Use um serviço de email que respeite sua privacidade. Eu escolhi o ProtonMail. Você pode usar o plano grátis deles, ou usar o plano pago para poder cadastrar seu domínio personalizado.

Eu recomendo ter um domínio personalizado, assim se quiser trocar de servidor no futuro, você não precisa recadastrar todos seus emails (Você vai ver como vai dar trabalho desassociar todas suas contas do Gmail, processo que venho fazendo aos poucos)

# Formatando o Celular

Com tudo pronto do lado do servidor, é hora de começar a trabalhar no celular. Neste guia, você vai usar o LineageOS como sistema principal, pois oferece um bom balanço entre uma distribuição Android Moderna e com poucas brechas de privacidade, que vamos corrigir durante o guia. 

Mas você não vai baixar o LineageOS diretamente do site, nós vamos usar a versão dele com o MigroG.

# O que é MicroG

O Android, apesar de ser de código aberto, é incompleto. Para manter o monopólio sobre o sistema e previnir que concorrentes fizessem sua própria versão do Android, o Google criou o Play Services, um serviço que roda em todo Android e que é essencial para a maior parte dos apps proprietários funcionarem.

É o Play Services que permite que seu celular forneça serviços de mapas e localização, notificações, loja de apps, entre outros.

Além disso, o Play Services é uma das principais fontes de rastreamento do Google, dado que ele roda 100% do tempo como um serviço, te rastreando e enviando dados para o Google.

Neste guia, não usaremos este serviço. No lugar, usaremos o [MigroG](https://microg.org/), uma implementação de código aberto do Play Services, que te dá mais controle do que você envia para o Google, além de não enviar dados de analytics.

# Instalando o LineageOS com o MicroG

Primeiramente você precisa desbloquear o bootloader do seu aparelho. [Vá no site do LineageOS](https://download.lineageos.org/), ache o seu aparelho, e siga as instruções para instalar o sistema no seu aparelho.

Quando chegar no passo em que você vai insalar a imagem principal no seu aparelho (A que pesa em torno de 1GB), não instale a versão do site do LineageOS. [Baixe a versão com MigroG neste site](https://download.lineage.microg.org/), e use ela no lugar da versão padrão do LineageOS. A diferença é que esta versão já vem com o MicroG e outros utilitários instalados para você, facilitando o processo.

Quando terminar o tutorial, não reinicie seu celular ainda, vamos habilitar root nele.

# Por que root? Não é inseguro?

Root permite que você instale diversos apps que irão aumentar a segurança do seu aparelho. Root em si não é uma coisa ruim, se você usa Linux, você deve ter o usuário root habilitado, e provavelmente rodou vários comandos com `sudo`. Até no Windows você roda comandos como administrador. Não há motivos para acreditar que você não tenha responsabilidade para rodar comandos como root no seu telefone.

# Instalando o Magisk

O Magisk é o app que habilitar root no seu sistema. No menu de recovery do LineageOS (o mesmo que você usou para instalar o sistema), vá no menu para instalar um update do ADB, conecte o celular no seu computador, baixe o arquivo zip [deste site](https://magisk.me/zip/) e rode:
```
adb sideload <arquivo.zip>
```

Se der um aviso de assinatura inválida, apenas confirme.

Reinicie seu aparelho, e abra o app do Magisk para concluir a instalação.

# E agora?

Parabéns, você tem um Android Limpo, com Root, e sem os serviços do Google. Tome algum tempo para configurar seu aparelho, deixar ele a sua cara. 

Não se esqueça de abrir o app do MicroG e habilitar as opções que te agradam (eu habilito todas).

Depois disso, vamos instalar alguns Apps com o F-Droid.

# F-Droid?

O F-Droid é uma loja de aplicativos para Android, de código aberto, e auditada. Para um app entrar no F-Droid, não basta que ele dizer ser de código aberto. Todos os apps são compilados da fonte automaticamente, e existe um sistema que detecta dependências e garante que o app é 100% de código aberto.

Se você instalou o LineageOS com MigroG, você já tem o F-Droid instalado e habilitado. Abra o app, e habilite atualizações automáticas de aplicativos nas configurações.

Abaixo vamos passar por uma seleção de apps open source que irão substituir a maior parte dos seus antigos apps proprietários, dando foco em apps chave para que seu celular seja usado em seu máximo potencial.

# Aurora Store / Aurora Services

Se você reparar, não tem a Google Play no seu telefone, e pelo F-Droid você não vai conseguir instalar apps proprietários. A realidade é que ainda precisamos desses apps, então vamos instalar a Aurora Store para isso.

Aurora Store é uma implementação open source da Google Play, e irá permitir que você instale apps proprietários. Você pode instalá-la no F-Droid.

Além disso, você também vai instalar o Aurora Services, que permite a instalação de apps no plano de fundo (igual a Play Store). [Baixe no Gitlab do Aurora](https://gitlab.com/AuroraOSS/AuroraServices/-/releases), a versão "Magisk Only". Use o App do Magisk para instalar, e reinicie o telefone.

Dentro da Aurora Store, selecione a opção "Aurora Services" como meio de instalação. Além disso, algumas configurações importantes:

- Dentro do menu de updates, caso apareça "Google Play Services" como um app para atualizar, adicione ele na blacklist. Isso é o Google achando que o MigroG é uma versão do Play Services, e deve ser ignorado.
- Dentro de configurações, vá em "Networking" e habilite "Insecure anonymous session". Isso vai te permitir a instalar apps que só estão disponíveis no Brasil, ao custo do Google saber que você está no Brasil.

Ainda não instale seus apps proprietários, vamos explorar as alternativas no F-Droid primeiro.

# Nextcloud

Agora é uma boa hora para instalar e logar no seu servidor Nextcloud, sendo sua alternativa ao Google Drive. No Nextcloud, você pode configurar a opção de auto upload de arquivos de mídia, assim você tem backup automático das suas fotos na nuvem.

# Davx5

Se você usa contatos / calendário / tarefas esse app é indispensável. Ele permite que você sincroinze seu calendário de diversos serviços (inclusive do Nextcloud) e integrado com o seu Android. Instale ele, e siga as instruções para configurá-lo.

Uma vez instalado, vá no seu app do Nextcloud, e nas configurações, toque na opção para configurar o Daxv5. Assim seu calendário, contatos e tarefas do Nextlcoud estarão sincronizados com o Android e vice versa.

E não se esqueça de desabilitar a otimização de bateria para este app, assim ele funcionará corretamente.

Caso você ainda precise de configurar calendários do Google ou outros serviços (eu uso para trabalho por exemplo), [você pode seguir este guia para configurá-lo](https://www.davx5.com/tested-with)

# Gotify-UP

Com o MicroG, nós temos acesso ao FCM, serviço proprietário do Google de notificações para 99% dos apps proprietários que você usa. Isso não quer dizer que não devemos instalar uma alternativa open source, no caso o UnifiedPush.

Devemos suportar alternativas ao Google, e na realidade, alguns apps abaixo irão usar desse app para entregar notificações. Basta instalar o app no F-Droid, desabilitar a otimização de bateria, e fazer a configuração nele. [Leia mais aqui](https://unifiedpush.org/users/intro/). O servidor padrão de notificações é [https://gotify1.unifiedpush.org](https://gotify1.unifiedpush.org)

# Backups

OAndBackupX te permite criar backups locais caso algo dê errado. Crie uma pasta de Backup na raiz do seu telefone, e configure para fazer backups diários, mantendo apenas 1 backup para economizar espaço. Assim se você errar, poderá recuperar apps e configurações.

# OpenBoard

Particularmente acho o teclado do LineageOS horrível. Felizmente temos o OpenBoard, disponível no F-Droid, com bom suporte ao Português, e totalmente offline. Maravilhoso.

# Tarefas

Tasks é um app no F-Droid que em conjunto com o Daxv5 permite sincronizar tarefas e notas do Nextcloud para seu celular e vice versa.

# AdAway

Esse app é essencial para sua privacidade. Ele edita o arquivo de hosts do seu celular, impedindo que ele se conecte com servidores de rastreamento e propagandas. Sem custo nenhum para sua bateria. Instale ele do F-Droid, e nas configurações, ative o servidor local e instale o certificado. Assim os sites vão achar que estão se conectando nos servidores de analytics, mas estarão conectando no seu servidor local, e não irão quebrar.

# Mapas

Infelizmente nenhum app de mapas está a altura do Google Maps / Waze. Felizmente, ambos funcionam com o MicroG. Basta instalar na Aurora Store e usar.

O melhor app de mapas alternativo que achei foi o Magic Earth, também proprietário. Todas alternativas do F-Droid me deixaram na mão de um jeito ou de outro.

# Produtividade

- **Calendário**: Uso o que vem com o LineageOS. Com o Daxv5, a sincronização é automática.

- **2 Factor Auth**: Aegis é um app que substitui Auth/Google Authenticator, com opção de backup dos seus códigos, que recomendo deixar ativo.

- **Gestor de Senhas**: Bitwarden tem app para todas as plataformas, é grátis, código aberto, criptografado, simplesmente o melhor app que existe da categoria. [Instale o repositório do F-Droid escaneando o QR Code](https://mobileapp.bitwarden.com/fdroid/) e instale pelo cliente do F-Droid

- **Documentos**: Uso o Collabora Office para arquivos odf, e o Only Office (Proprietário, na Aurora Store) para arquivos do MS Office, PDF, e outros.

- **Contatos**: Uso o app padrão do LineageOS, com o Daxv5 para sincronização.

- **Chat**: O Telegram e o Element estão no F-Droid, e o Whatsapp na Aurora Store.

- **Browser**: Use o Fennec no F-Droid. É um port do Firefox, removendo as biblitotecas proprietárias da Mozilla. Vamos falar melhor de Browser depois.

- **Arquivos**: Material Files é um app avançado para gestão de arquivos no Android. O gestor padrão do LineageOS é decente também.

- **Calendário de feriados**: ICSx5 permite que você cadastre calendários de feriados e eventos. Vá no [webcal.guru](https://www.webcal.guru), ache os calendários que te agradam, e instale eles no ICSx5. Eu uso o de feriados brasileiros, americanos e de eventos interessantes.

- **Email**: K9 Mail permite que você configure qualquer email no seu celular. ProtonMail está disponível na Aurora Store para instalação também. Vamos falar melhor de como usar o K9 Mail abaixo.

- **Integração com o Computador**: KDE Connect permite que você transfira arquivos, texto, e notificações entre seu PC e o seu celular. Melhor app da categoria, muito útil no dia a dia.

#### Mídia
- **Podcasts**: AntennaPod usa o backend do Itunes para sincronizar podcastas no seu celular, sem login com a Apple.

- **QR Codes**: Binary Eye é o melhor app que já vi da categoria, grátis e open source.

- **Câmera**: Eu uso a padrão do LineageOS, mas no F-Droid tem o OpenCamera que é muito bom também

- **Galeria**: Simple Gallery Pro é um app simples porém completo para gestão das suas fotos

- **Álbums Online**: Les Pas é um belíssimo app para você sincronizar seus álbums com o NextCloud. Meu substituto do Google Fotos.

- **SMS**: App padrão do LineageOS funciona muito bem.

- **Música**: Eu criei minha playlist no Newpipe, que vamos explorar abaixo. Para reprodução offline, eu uso o próprio app do LineageOS.

# Redes Sociais
- **Instagram**: Esse é complexo, pois o próprio Facebook bloqueia as soluções de código aberto. Eu uso o [Instander](https://thedise.me/instander/) para ter o Instagram logado no telefone, e o Barinsta, que está no F-Droid, para acessar no dia a dia. Usando só o Barinsta é bem provável que sua conta será banida temporariamente.

- **Reddit**: Infinity é o melhor cliente open source para Reddit, funciona perfeitamente.

- **Youtube**: O NewPipe te permite criar playlists e se inscrever em canais no YouTube sem ter conta. Também dá para ouvir em background e baixar vídeos, assim você pode criar playlists e usar como se fosse um app de música. [Existe uma versão turbinada com SponsorBlock no IzzyOnDroid](https://apt.izzysoft.de/fdroid/index/apk/org.polymorphicshade.newpipe).

- **Twitch**: Twire é um cliente open source para acessar a Twitch.tv, excelente se seu foco é assistir as lives.

# Outros
- **Cupons e ingressos**: Catima permite que você organize seus ingressos e cupons. Uso para salvar shows, vôos, e qualquer coisa que use um QR Code.

- **Find My Device**: FindMyDevice é um app open source disponível no F-Droid que te permite localizar seu telefone e inultilizá-lo em caso de perda. [Você pode inclusive hospedar seu próprio servidor se preferir](https://gitlab.com/Nulide/findmydevice/-/wikis/FMD%20Server).

- **Gadgets**: GadgetBridge integra meu Amazfit Bip perfeitamente, dispensando seu app proprietário. [Leia a Wiki para configurar seu dispositivo](https://codeberg.org/Freeyourgadget/Gadgetbridge/wiki).

- **Hábitos**: Githo permite que você desenvolva rotinas de forma simples e saudável.

# Alguns Apps Proprietários
- **Carteira Nacional de Trânsito**: Como tenho um carro, uso esse app para salvar meus documentos. Funciona perfeitamente.

- **Bancos**: Nubank, Inter, Nomad, Wise e Itaú funcionam perfeitamente. C6 Bank não roda em aparelhos com Root. Não testei outros para dizer como são.

- **Corretoras**: Testei a XP, Nu Invest, Mututal e Iteractive Brokers. Não tive problemas.

- **Finanças**: FluxoPay para finanças empresariais, Kinvo para investimentos. Funcionam perfeitamente.

- **Jogos**: Eu não jogo no celular, mas tenho o app do Lichess instalado para brincar de Xadrez de vez em quando.

- **Vendas Online**: Mercado Livre, OLX, Mercado Pago funcionam normalmente.

- **Trabaho**: Uso Slack no trabalho, funciona perfeitamente.

- **Edição de Imagem**: O SnapSeed funciona perfeitamente.

- **Steam**: Funciona perfeitamente.

- **Mobilidade**: Uber funciona, mas o mapa fica bugado (quase todos os mapas de apps proprietários ficam bugados). Nada que impeça de usar o app. Não testei outros apps, mas o problema do mapa bugado é recorrente em vários apps proprietários que usam APIs recentes do Google Maps (Ifood por exemplo).

- **Comunicação**: Whatsapp funciona perfeitamente.

# Navegando na Internet

Nunca, em hipótese alguma, use o Google Chrome para navegar na internet. Se você chegou aqui, não faz sentido deixar seu principal ponto de comunicação com a Internet nas mãos do Google.

Hoje estamos em uma internet que está ameaçada. Com o domínio do Chromium e seus derivados (Chrome, Vivaldi, Brave, Opera, Edge, etc), estamos caminhando a passos largos para uma internet centralizada na mão de corporações, o que vai totalmente contra o conceito da internet. Já tentou abrir o Teams no Firefox para ver o que acontece? A Microsoft proíbe de propósito, te forçando a usar browsers baseados no Chromium.

Se você não se importa com os fatos acima, o [Bromite](https://github.com/bromite/bromite) é uma boa alternativa ao Chrome.

Agora, se você realmente quer ajuar a ter uma internet mais livre, use o Firefox. É um excelente navegador, e existe vantagens claras em usar ele, como suporte a extensões.

No F-Droid, o Firefox aparece como Fennec, pois a Mozilla adiciona algumas bibliotecas proprietárias que não compilam com o F-Droid.

Uma vez instalado, instale as seguintes extensões:
- Privacy Badger: Bloqueia cookies e rastreaores invasivos do seu celular
- Ublock Origin: Bloqueia mais cookies, anúncios e rastreadores
- Bitwarden: Integra o gestor de senhas no mobile

Um adendo, no seu computador, instale a extensão de Containeres para o Firefox. Ela te permite configurar perfis diferentes para suas atividades, isolando sites invasivos da sua navegação diária. Excelente para sua privacidade. Eu separo da seguinte forma:
- Google
- Facebook
- Trabalho
- Sites extremamente invasivos

# Email do Google (Gmail, Gsuite)

Caso você ainda precise usar algum serviço de email do Google no seu celular, configure a autenticação de dois fatores nas configurações da sua conta, e crie uma [senha de aplicativo](https://support.google.com/mail/answer/185833?hl=pt-BR).

No K9 mail, tanto nas configurações de IMAP e SMTP, coloque a senha de app ao invés da sua senha do google e o K9 irá sincronizar seus emails corretamente. Também funciona para o GSuite.

# Bônus 1: Melhorando ainda mais sua privacidade

Alguns apps que melhorariam sua privacidade ficaram de fora do guia, abaixo explico o por que.

**Shelter**

Este app permite que você configure um perfil separado no seu telefone, onde você pode instalar apps invasivos, e eles não se comunicam com seu perfil principal (não podem acessar arquivos e configurações por exemplo). Como é extremamente chato duplicar todas suas configurações entre os perfis, eu acabei não usando. Literalmente são dois perfis, nem seu teclado vai funcionar igual entre eles. Eu não gostei da ideia de duplicar vários apps no perfil secundário.

**AfWall+**

Este app atua como um Firewall, bloqueando acesso a internet de apps que não precisam. Seria um app indispensável no guia, se ele não conlfitasse com o AdWall e bugasse na hora de aplicar regras de IVP6. Recomendo que teste no seu telefone, e caso funcione, mantenha. Se não funcionar, remova, dado que a maior parte dos seus apps precisam de acesso a internet de qualquer forma.

**Orbot**

Este app configura uma VPN no seu celuar, e roteia tráfego de apps que você escolher pela rede TOR, impedindo que esses apps te identifiquem. O app é excelente, porém eu tive problemas de performance (esperado por passar pelos nós da rede TOR), então acabei não usando na prática.

**SuperFrezz**

Este app permite que você congele apps de forma inteligente, bloqueando eles de rodarem no plano de fundo. Na prática, como quase todos meus apps são open source, não senti necessidade de congelar nenhum app. Além disso, congelar apps drena mais bateria se você os usa muito.

**Autostarts**

Este app previne que aplicativos iniciem com o sistema. Provavelmente eu não o configurei direito, mas em cada reinicialização, alguns apps "resetavam" seu estado, desfazendo minhas configurações e iniciando com o sistema. Por isso não estou usando no momento, mas provavelmente é culpa minha.

# Bônus 2: Servidor de DNS

Se você chegou aqui, parabéns! Aproveite seu celular privado, mais leve, performático, e seguro para uso. Como você provavelmente tem um Raspberry Pi instalado na sua rede local, que tal instalar um DNS 100% privado e com bloqueador de anúncios e rastreadores?

Das duas uma: ou seu DNS está apontado para alguma corporação (Google, Cloudfare, etc) ou está apontado para seu provedor de internet. Ambos são ruins, vamos consertar isso.

PiHole é um servidor DNS que filtra anúncios e rastreadores, oferecendo uma interface web para configuração.

[Siga esse tutorial para instalá-lo no seu Raspberry Pi](https://docs.pi-hole.net/main/basic-install/).

Depois disso, [garanta que o seu Raspberry Pi tem IP Fixo com esse guia](https://raspberrypi-guide.github.io/networking/set-up-static-ip-address)

No seu roteador, configure o Raspberry como seu servidor de DNS IPV4 e IPV6. Se isso não é possível, você pode [configurar seu PiHole para ser seu serviror DHCP](https://discourse.pi-hole.net/t/how-do-i-use-pi-holes-built-in-dhcp-server-and-why-would-i-want-to/3026)

E por fim, [siga esse tutorial para configurar o Unbound](https://docs.pi-hole.net/guides/dns/unbound/), um servidor recursivo de DNS, assim suas queries deixam de ir para o Google e passam a ir diretamente para os servidores autoritativos, e você não será rastreado.

Muito obrigado por ler até aqui! Se quiser falar comigo, [pode me enviar um email](mailto:contato@brennoflavio.com.br). Obrigado!
