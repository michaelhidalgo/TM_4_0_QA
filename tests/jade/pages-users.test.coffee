QA_TM_Design = require './../API/QA-TM_4_0_Design'

# this test suite contains all  all pages that we currently need to support for logged in  users
describe 'jade | pages-users', ->
  page = QA_TM_Design.create(before, after);
  jade = page.jade_API;

  afterEach (done)->
    page.html (html,$)->
      $('title').text().assert_Is('TEAM Mentor 4.0 (Html version)')         # confirm that all pages have the same title
      check_Top_Right_Navigation_Bar($)
      done()

  check_Top_Right_Navigation_Bar = ($)->                                    # confirm that all anonymous pages have the same top level menu
    navBarLinks = $('#links li a')                                          # get all top right links using a css selector
    navBarLinks.length.assert_Is(4)                                         # there should be 5 links

    linksData = for link in navBarLinks                                     # for each link in navBarLinks
      {                                                                     # create a new object
        link_attr : $(link).attr(),                                         # with the link attributes
        img_attr  : $($(link).find('i')).attr()                             # the img attributes
        text: $(link).text()                                               # and the value (which is the innerText)
      }

    checkValues = (index, link_attr,img_attr, text ) ->                 # create a helper function to check for expected values
      using linksData[index],->
        @.link_attr.assert_Is link_attr
        @.img_attr .assert_Is img_attr
        @.text     .assert_Is text

    checkValues(0, {"href":'/user/main.html' }, { class: 'fi-magnifying-glass'}, 'Search'    )
    checkValues(1, {"href":'/graph/Guidance'    }, { class: 'fi-map'             }, 'Navigate')
    checkValues(2, {"href":'/help/index.html'}, { class: 'fi-info'            }, 'Help'    )
    checkValues(3, {"href":'/user/logout'    }, { class: 'fi-power'           }, 'Logout'  )

  before (done)->
    jade.login_As_QA  ->
      done()

  it 'Help', (done)->
    jade.page_User_Help (html,$)->
      section_Titles = ($(h4).html() for h4 in $('h4'))
      section_Titles.assert_Is([ 'About TEAM Mentor',
                                 'Installation',
                                 'Administration',
                                 'UI Elements',
                                 'Reading Content',
                                 'Editing Content',
                                 'Eclipse for Fortify plugin',
                                 'HP Fortify SCA UI Integration',
                                 'Visual Studio Plugin',
                                 'TEAM Mentor in action:',
                                 'TEAM Mentor Related Sites' ])
      done()

  it 'Library', (done)->
    jade.page_User_Library (html,$)->
      links_Libraries = $('#links-libraries a')
      $(links_Libraries.get(0)).html().assert_Is('Guidance')
      $(links_Libraries.get(0)).attr().assert_Is({ id: 'link-my-articles', href: '/library/Uno' })
      $(links_Libraries.get(1)).html().assert_Is('Library Queries')
      $(links_Libraries.get(1)).attr().assert_Is({ id: 'link-my-articles', href: '/library/queries' })

      values = ($(link).text() for link in $('#links-library a'))
      values.assert_Is([ 'Data Validation',
                         'Logging',
                         'Separation of Data and Control',
                         '(Web) Encoding',
                         '(Web) Session Management',
                         'Cryptographic Storage',
                         'System Hardening',
                         'Authentication',
                         'Authorization',
                         'Canonicalization',
                         'Administrative Controls',
                         'Communication Security',
                         'Error Handling' ])
      done()

  it 'Logout', (done)->
    jade.page_User_Logout (html,$)->
      page.chrome.url (url)->
        url.assert_Contains('/guest/default.html')
        jade.login_As_QA ->
            done()

  it 'Main', (done)->
    jade.page_User_Main (html,$)->
      section_Titles = ($(h4).html() for h4 in $('h4'))
      section_Titles.assert_Is(['Recently Viewed Articles','Popular Search Terms','Top Articles'])
      done()

  it 'page_User_Graph_All', (done)->
    jade.page_User_Graph_All (html,$)->
      done()