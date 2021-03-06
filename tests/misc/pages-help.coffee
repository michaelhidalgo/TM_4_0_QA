QA_TM_Design = require '../API/QA-TM_4_0_Design'
async        = require('async')

describe '| misc | pages-help |', ->
  page = QA_TM_Design.create(before, after)
  jade = page.jade_API

  help_Pages = []

  it 'check nav link (when user is logged out)', (done)->
    jade.logout ->
      page.open '/help/index.html', (html,$)->
        $('#nav-login').text().assert_Is 'Login'
        $('#nav-help' ).text().assert_Is 'Docs'
        done()

  it 'check nav link (when user is logged in)', (done)->
    @timeout 10000
    jade.login_As_User ->
      page.open '/help/index.html', (html,$)->
        $('#nav-user-logout').text().assert_Is 'Logout'
        $('#nav-user-help'  ).text().assert_Is 'Docs'
        done()

  it 'check right navigation links', (done)->
    page.open '/help/index.html', (html,$)->
      help_Pages = ({href : link.attribs.href, title: $(link).html()} for link in $('#help-nav a'))
      help_Pages.assert_Size_Is(45)
      help_Pages[10].title.assert_Is('Forgot Password'                    )  #check a couple to see if they are still the ones we expect
      help_Pages[20].title.assert_Is('Active Directory Support'           )
      help_Pages[30].title.assert_Is('Requirements'                       )
      help_Pages[40].title.assert_Is('Installation'                       )
      done()


  xit 'check that image redirection to github is working', (done)->
    image   = 'tmcfg12.jpg'
    url     = "#{page.tm_Server}/Image/#{image}"
    message = "Moved Temporarily. Redirecting to https://raw.githubusercontent.com/TMContent/Lib_Docs/master/_Images/#{image}"
    url.GET (html)->
        html.assert_Is message
        done()

  it 'open two pages and check that titles match', (done)->
    @.timeout 5000
    open_Help_Page = (help_Page, next)->
      page.open help_Page.href,(html,$)->
        $('#help-title').html().assert_Is help_Page.title
        article_Title = $('#help-title').html()
        article_Title.assert_Is(help_Page.title)                 # confirms title of loaded page matches link title
        $('#help-content').text().size().assert_Bigger_Than(100) # confirms there is some text on the page
        next()
    async.eachSeries help_Pages.take(2), open_Help_Page, done

  it 'open "empty page" page (aaaaa-bbb)',(done)->
    jade.page_Help_Page 'aaaaa-bbb', (html, $)->
      $('#help-title'  ).text().assert_Is 'No content for the current page'
      $('#help-content').text().assert_Is ''
      done()

  it 'open "index" page (index.html)',(done)->
    jade.page_Help_Page 'index.html', (html, $)->
      $('#help-title'  ).text().assert_Is 'Introduction to TEAM Mentor'
      $('#help-content').text().assert_Contains 'TEAM Mentor is an interactive Application Security library'
      done()

  it 'open "Managing Users" page (00000000-0000-0000-0000-0000001c8add)',(done)->
    @timeout 4000
    jade.page_Help_Page '00000000-0000-0000-0000-0000001c8add', (html, $)->
      $('#help-title'  ).text().assert_Is 'Managing Users'
      $('#help-content').text().assert_Contains 'Administrators can manage TEAM Mentor users via the Tbot.'
      first_Img_Link = $('#help-content img').first().attr().src.assert_Is '/Image/tmcfg12.jpg'
      done()

  it 'open "Support" page (323dae88-b74b-465c-a949-d48c33f4ac85)',(done)->
    jade.page_Help_Page '323dae88-b74b-465c-a949-d48c33f4ac85', (html, $)->
      $('#help-title'  ).text().assert_Is 'Support'
      $('#help-content').text().assert_Is 'To contact Security Innovation TEAM Mentor support please email support@securityinnovation.com \n \n'
      done()