var saucyStyles = {}
var saucyElements = []


function property_to_url_attr(s)
{
   attr = s.split('-')
   ret = {'renderer':attr[0].substring(0,1), 'url_attr' : ''}

   for(i=1; i<attr.length;i++)
   {
     ret['url_attr']  += attr[i].substring(0,1)
   }

   if(ret.renderer == 'p')
     ret.url_attr = 'p' + ret.url_attr

   return ret
}

function saucyGetCSSforElement(e)
{
    saucy_html=document.getElementById('saucy_style').innerHTML
    rules = saucy_html.split('}')
    ret = null
    rules.each(function(rule)
    {
        rule = rule.replace(/\s/g,'')
        klass_match = rule.match(/^.*{/)
        styl3s_match = rule.match(/{.*/)
        if(klass_match && styl3s_match)
        {

            if(klass_match == e + '{')
            {
                styl3 = styl3s_match[0].substring(1,styl3s_match[0].length).replace(/ /g,'').replace(/}/g,'') //no spaces please
                styl3 = styl3.replace(/;/g,";<br>")
                ret = styl3
            }
        }
    })
    return ret
}


function saucyGetStylesfromHTML()
{
  saucy_html=document.getElementById('saucy_style').innerHTML
  rules = saucy_html.split('}')

  rules.each(function(rule)
  {
    //rule = rules[i]
    rule = rule.replace(/\s/g,'')

    klass_match = rule.match(/^.*{/)
    styl3s_match = rule.match(/{.*/)
    if(klass_match && styl3s_match)
    {
      klass = klass_match[0].substring(0,klass_match[0].length-1).replace(/ /g,'') //no spaces please
      styl3 = styl3s_match[0].substring(1,styl3s_match[0].length).replace(/ /g,'').replace(/}/g,'') //no spaces please
      if(klass && styl3)
      {
        styl3s = styl3.split(';')

        styl3s_hash = {}

        styl3s.each(function(sty){
          if(sty != null && sty.length != 0)
          {
            splt = sty.split(':')

            prop = splt[0].replace(/ /g,'')

            url_attr = property_to_url_attr(prop)

            s_value = splt[1].replace(/ /g,''); //no spaces please

            if(!styl3s_hash[url_attr.renderer])
              styl3s_hash[url_attr.renderer]={}

            styl3s_hash[url_attr.renderer][url_attr.url_attr] = s_value
          }
        })
        saucyStyles[klass]=styl3s_hash
      }
    }
  })
}

function saucyApplytoElements()
{
  saucyElements = []
  for(selector in saucyStyles)
  {
    var elements = $$(selector);

    var rule_hash=saucyStyles[selector]
    if(!rule_hash)
      continue

    for (var i = 0; i < elements.length; i++)
    {
      element = elements[i]

      if(saucyElements.indexOf(element) == -1)
      {
        saucyElements[saucyElements.length] = element
      }
      element.saucy_style = element.saucy_style || {}

      for(renderer in rule_hash)
      {
        if(!element.saucy_style[renderer])
          element.saucy_style[renderer]={}

        for(attr in rule_hash[renderer])
        {
          element.saucy_style[renderer][attr]=rule_hash[renderer][attr]
        }
      }
    }
  }
}

function saucyDomReady()
{
    saucyGetStylesfromHTML()
    saucyApplytoElements()
    saucyDoRendering()
    fixPngsinIE()
}

function saucyDoRendering()
{
    saucyElements.each(function(e)
    {
      if(e.saucy_style.t)
        apply_ttf(e)
      if(e.saucy_style.c)
        apply_curve(e)
      if(e.saucy_style.g)
        apply_gradient(e)
      if(e.saucy_style.p)
        apply_post(e)
    })
}

/******* OTHER THAN IE AND MOZILLA ?? *******/
function computedStyle(x)
{
    if (x.currentStyle)
        var y = x.currentStyle
    else if (document.defaultView && document.defaultView.getComputedStyle)
    {
        try
        {
            var y = document.defaultView.getComputedStyle(x,'')
        }
        catch(e){}
    }
    return y
}

function effectiveBackgroundColor(el)
{
    back=null
    while(el && back==null)
    {
        cs = computedStyle(el)
        if(cs)
            bc = cs.backgroundColor

        if(bc != '' && bc != 'none' && bc != 'transparent')
        {
            back = bc
        }

        el = el.parentNode
    }
    if(back==null)
        back='transparent'
    return back
}

function normalize_color(input) //different browsers may give back different forms of color
{

    ret = input
    //convert for safari
    if(ret == 'rgba(0, 0, 0, 0)')
      ret='transparent'

    // convert rgb(xxx,xxx,xxx) -> #yyyyyy
    re = /^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$/
    prc = (ret + '').replace(/ /g,'');
    prc = prc.toLowerCase();
    bits = re.exec(prc)
    a=false
    if(bits)
    {
        r = parseInt(bits[1])
        g = parseInt(bits[2])
        b = parseInt(bits[3])
        ret = toHEX(r,g,b)
        a=true
    }

    // convert #aabbcc-> #abc
    re = /^#[a-z0-9]{6}$/
    prc = (ret + '').replace(/ /g,'');
    prc = prc.toLowerCase()
    if(re.exec(prc))
    {

        if(prc.charAt(1) == prc.charAt(2) && prc.charAt(3)== prc.charAt(4) && prc.charAt(5)==prc.charAt(6))
        {
            ret = '#' + prc.charAt(1) + prc.charAt(3) + prc.charAt(5)
        }
    }

    // replace # with HX
    re = /^#[a-z0-9]{3,6}$/
    prc = (ret + '').replace(/ /g,'');
    prc = prc.toLowerCase()
    if(re.exec(prc))
    {
        ret = prc.replace('#','H') // # gets mangled in CGI
    }


    return ret
}

function toHEX(r,g,b)
{
    r = r.toString(16);
    g = g.toString(16);
    b = b.toString(16);
    if (r.length == 1) r = '0' + r;
    if (g.length == 1) g = '0' + g;
    if (b.length == 1) b = '0' + b;
    return '#' + r + g + b;
}

function saucyCreateURL(typ, attr_hash, post_hash)
{
    post_background = 'white'

    if(post_hash && post_hash['pb'])  //should be there
    {
        post_background = post_hash['pb']
        post_hash['pb'] = null
    }

    value_separator = '-'
    pair_separator = '~'
    pairs=[]

    for(attr in attr_hash)
    {
        if(attr_hash[attr] == null)
            continue
        pairs[pairs.length] = attr + value_separator + normalize_color(attr_hash[attr])
    }

    for(attr in post_hash)
    {
        if(post_hash[attr] == null)
            continue
        pairs[pairs.length] = attr + value_separator + normalize_color(post_hash[attr])
    }

    file = pairs.join(pair_separator) + '~pb-' + normalize_color(post_background) + '.png'

    imageFile= "error"
    image = typ.substring(0,1) + pair_separator + file

    if(saucyRenderMode == 'passive')
       imageFile =  saucyRenderPassive  + image
    else if(saucyRenderMode == 'active')
       imageFile = saucyRenderActive + image
    else
      alert("Bad saucyRenderMode : " +  saucyRenderMode)
    return imageFile
}

function apply_ttf(element)
{
  computed_style = computedStyle(element)

  saucy_ttf = element.saucy_style['t']
  saucy_post  = element.saucy_style['p']

  if(!saucy_ttf['bc'])
    saucy_ttf['bc'] = computedStyle(element).backgroundColor

  if(!saucy_ttf['s'])
    saucy_ttf['s'] = parseInt(computed_style.fontSize)

  if(!saucy_ttf['c'])
    saucy_ttf['c'] = computed_style.color

  if(!saucy_ttf['f'])
    saucy_ttf['f'] = computed_style.fontFamily

  saucy_ttf['t'] = escape(element.innerHTML)

  ebc = effectiveBackgroundColor(element)
  if(saucy_post== null)
    saucy_post = {}
  if(saucy_post['pb'] == null)
    saucy_post['pb'] = ebc

  imageFile = saucyCreateURL('ttf', saucy_ttf, saucy_post)

  w= element.offsetWidth
  h= element.offsetHeight

  // as background
  element.innerHTML = '&nbsp;'
  element.style.backgroundImage = 'url("' + imageFile + '")'

  element.style.backgroundRepeat = 'no-repeat'
  element.style.width = w
  element.style.height=h
}

function apply_gradient(element)
{
  computed_style = computedStyle(element)
  saucy_post = element.saucy_style['p']

  /* DEFAULTS */
  saucy_gradient = element.saucy_style['g']

  if(saucy_gradient['bs'] == null)
    saucy_gradient['bs'] = computed_style.backgroundColor

  if(saucy_gradient['be']==null)
    saucy_gradient['be'] = computed_style.backgroundColor

  imageFile = saucyCreateURL('gradient', saucy_gradient, saucy_post)

  element.style.backgroundImage = 'url(' + imageFile + ')'

  if(saucy_gradient['d'] == 'v')
    element.style.backgroundRepeat = 'repeat-x'

  if(saucy_gradient['d'] == 'h')
    element.style.backgroundRepeat = 'repeat-y'
}

function apply_curve(element)
{
  saucy_curve = element.saucy_style['c']
  saucy_post = element.saucy_style['p']
  computed_style = computedStyle(element)

  outer_color = effectiveBackgroundColor(element.parent)
  inner_color = computed_style.backgroundColor
  if(inner_color && !saucy_curve['ic'])
    saucy_curve['ic']=inner_color

  if(outer_color && !saucy_curve['oc'])
    saucy_curve['oc']=outer_color

  if(computed_style.borderTopColor && computed_style.borderTopWidth != '0px' && computed_style.borderTopWidth != 'medium')
  {
    sc = computed_style.borderTopColor
    sw = computed_style.borderTopWidth
  }
  else
  {
    sc=saucy_curve['ic']
    sw=0
  }

  bTop = (computed_style.borderTopWidth == '0px') ? '0' : '1'
  bBottom = (computed_style.borderBottomWidth == '0px') ? '0' : '1'
  bLeft = (computed_style.borderLeftWidth == '0px') ? '0' : '1'
  bRight = (computed_style.borderRightWidth == '0px') ? '0' : '1'

  if(!saucy_curve['b'])
  {
    borders=bTop + bRight + bBottom + bLeft
    //if all 0 then assume its all the way round
    if(borders='0000')
      borders='1111'
    saucy_curve['b'] = borders

  }
  if(!saucy_curve['sc'])
    saucy_curve['sc']=sc
  if(!saucy_curve['sw'])
    saucy_curve['sw']=sw

  saucy_curve['w'] = element.offsetWidth
  saucy_curve['h'] = element.offsetHeight

  ebc = effectiveBackgroundColor(element.parentNode)
  if(saucy_post == null)
    saucy_post = {}
  if(saucy_post['pb'] == null)
    saucy_post['pb'] = ebc

  imageFile = saucyCreateURL('curve', saucy_curve, saucy_post)

  element.style.backgroundImage = 'url("' + imageFile + '")'

  try
  {
    element.style.paddingTop = parseInt(computedStyle(element).paddingTop) + parseInt(computedStyle(element).borderTopWidth) + 'px'
    element.style.paddingBottom = parseInt(computedStyle(element).paddingBottom) + parseInt(computedStyle(element).borderBottomWidth) + 'px'
    element.style.paddingLeft = parseInt(computedStyle(element).paddingLeft) + parseInt(computedStyle(element).borderLeftWidth) + 'px'
    element.style.paddingRight = parseInt(computedStyle(element).paddingRight) + parseInt(computedStyle(element).borderRightWidth) + 'px'
  }
  catch(e) {}

  if(outer_color == 'transparent')
    element.style.backgroundColor = 'transparent'
  element.style.border = '0px'

}

function apply_post(element)
{
    saucy_post = element.saucy_style['p']
    computed_style = computedStyle(element)

    /* fix Shadow paddings */
    if(saucy_post['ps'])
    {
        bot = parseInt(computedStyle(element).paddingBottom)
        rig  = parseInt(computedStyle(element).paddingRight)
        if(saucy_post['pst'])
        {
            bot += Math.abs(parseInt(saucy_post['pst']))
        }
        if(saucy_post['psl'])
        {
            rig += Math.abs(parseInt(saucy_post['psl']))
        }

        if(saucy_post['psr'])
        {
            bot += Math.abs(parseInt(saucy_post['psr']))
            rig += Math.abs(parseInt(saucy_post['psr']))
        }

        element.style.paddingBottom =  bot
        element.style.paddingRight =  rig
    }

    /* fix shadow rotations */
    if(saucy_post['pr'])
    {
        angle = parseInt(saucy_post['pr'])
        theta = angle * Math.PI / 180.0
        sin = Math.abs(Math.sin(theta))
        cos = Math.abs(Math.cos(theta))
        w = parseInt(element.style.width) //offsetWidth
        h = parseInt(element.style.height)

        element.style.width  =  Math.floor((w * cos) + (h* sin))
        element.style.height =  Math.floor((w * sin )+ (h * cos))

    }

    /* fix blur margin/padding ?? */
    return
    // later we could add shadows and rotations to other things...
}

/**************** IE5.5-6 PNG FIX ****************/
function fixPngsinIE()
{
    var version = parseFloat(navigator.appVersion.split('MSIE')[1]);
    if ((version >= 5.5) && (version < 7) && (document.body.filters))
    {
        $$('*').each(function(poElement)
        {
            // if IE5.5+ on win32, then display PNGs with AlphaImageLoader
            if (poElement.currentStyle.backgroundImage.match(/transparent\.png/))
            {
                var cBGImg = poElement.currentStyle.backgroundImage;
                var cImage = cBGImg.substring(cBGImg.indexOf('"') + 1, cBGImg.lastIndexOf('"'));
                poElement.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + cImage + "', sizingMethod='crop')"; //scale?
                poElement.style.backgroundImage = "none";
            }
        });
    }
}

/************* END PNGFIX *************/
