exports = this
exports.Lijiaweb = exports.Lijiaweb || {}

class exports.Lijiaweb.SwiperLijia
  @init: ->
    if $('.pc-slideshows-swiper').length > 0
      @_binding_pc_slideshows_swiper()
    if $('.pc-button-swiper').length > 0
      @_binding_pc_button_swiper()
    if $('.pc-course-swiper').length > 0
      @_binding_pc_course_swiper()

    if $('.mb-course-swiper').length > 0
      @_binding_mb_course_swiper()
    if $('.page-slideshows-swiper').length > 0
      @_binding_page_slideshows_swiper()
    if $('.mobile-slideshows-swiper').length > 0
      @_binding_mobile_slideshows_swiper()
    if $('.gallery-top').length > 0
      @_binding_gallery_swiper()
  @_binding_pc_button_swiper: ->
    pcButtonSwiper = new Swiper('.pc-button-swiper',
      navigation:
        nextEl: '.swiper-button-next'
        prevEl: '.swiper-button-prev'
      slidesPerView: 3
      spaceBetween: 15
    )

  @_binding_pc_course_swiper: ->
    pcButtonSwiper = new Swiper('.pc-course-swiper',
      navigation:
        nextEl: '.swiper-button-next'
        prevEl: '.swiper-button-prev'
      slidesPerView: 4
      spaceBetween: 15
    )

  @_binding_mb_course_swiper: ->
    pcButtonSwiper = new Swiper('.mb-course-swiper',
      navigation:
        nextEl: '.swiper-button-next'
        prevEl: '.swiper-button-prev'
      slidesPerView: 2
      spaceBetween: 10
    )

  @_binding_pc_slideshows_swiper: ->
    pcSwiper = new Swiper('.pc-slideshows-swiper',
      autoplay: true
      pagination:
        el: '.pc-swiper-pagination'
      paginationClickable: true
      centeredSlides: true
      autoplayDisableOnInteraction: false
      observer: true
      observeParents: true
    )
    if $('.pc-slideshows-swiper').length > 0
      $(window).resize ->
        pcSwiper.update()
  @_binding_mobile_slideshows_swiper: ->
    mobileSwiper = new Swiper('.mobile-slideshows-swiper',
      pagination: '.mobile-swiper-pagination'
      paginationClickable: true
      centeredSlides: true
      autoplay: 5000
      autoplayDisableOnInteraction: false
      observer: true
      observeParents: true
    )
    if $('.mobile-slideshows-swiper').length > 0
      $(window).resize ->
        mobileSwiper.update()
  @_binding_gallery_swiper: ->
    galleryTop = new Swiper('.gallery-top',
      spaceBetween: 10
      autoplay: 5000
      effect: 'fade'
      autoplayDisableOnInteraction: true
      followFinger: true
      grabCursor: true
      onSlideChangeEnd: (swiper) ->
        swiper.stopAutoplay()
        swiper.startAutoplay()
    )
    galleryThumbs = new Swiper('.gallery-thumbs',
      slidesPerView: 5
      touchRatio: 0.2
      spaceBetween: 15
      slideToClickedSlide: true
      virtualTranslate: true
      centeredSlides: true
      grabCursor: true
    )
    galleryTop.params.control = galleryThumbs
    galleryThumbs.params.control = galleryTop

    if $('.gallery-top').length > 0
      $(window).resize ->
        galleryTop.update()
        galleryThumbs.update()

    $('.gallery-top .swiper-wrapper .swiper-slide').on 'mouseover', ->
      galleryTop.stopAutoplay()
    $('.gallery-top .swiper-wrapper .swiper-slide').on 'mouseout', ->
      galleryTop.startAutoplay()
    $('.gallery-thumbs .swiper-wrapper .swiper-slide').on 'mouseover', ->
      index = $(".gallery-thumbs .swiper-wrapper .swiper-slide").index($(this))
      galleryThumbs.slideTo(index, 0, false)
      galleryTop.stopAutoplay()

    $('.gallery-thumbs .swiper-wrapper .swiper-slide').on 'mouseout', ->
      galleryTop.startAutoplay()
