<template>
  <div :class="classObj" :style="styleObj" v-if="alive" ref="notification">
    <div class="va-notification-dialog" :style="{'width': width }">
      <div class="va-notification-content">
        <div :class="`va-notification-content-inner-${type}`">
          <div :class="`va-notification-content-inner-${type}-left`">
            <va-icon :style="styleText" style="font-size: 1rem"  class="va-notification-content-text" :type="notificationIconType"/>
          </div>
          <div :class="`va-notification-content-inner-${type}-right va-notification-content-text`">
            <div :class="`va-notification-content-inner-${type}-right-close`">
              <div style="cursor: pointer" @click="close">
                <va-icon size="16px" class="va-notification-content-text" type="times"/>
              </div>
            </div>
            <div
              :class="`va-notification-content-inner-${type}-right-title va-notification-content-text`"
            >{{title}}</div>
            <div
              :class="`va-notification-content-inner-${type}-right-message va-notification-content-text`"
              v-if="message"
              v-html="message"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import element from '../utils/element'

export default {
  name: 'VaNotification',
  props: {
    title: {
      type: String,
      default: '',
      required: false
    },
    message: {
      type: String,
      default: '',
      required: false
    },
    show: {
      type: Boolean,
      default: false,
      required: false
    },
    width: {
      type: String,
      default: '440px',
      required: false
    },
    effect: {
      type: String,
      default: 'fade-left',
      required: false
    },
    type: {
      type: String,
      default: 'default',
      required: false
    },
    duration: {
      type: Number,
      default: 0,
      required: false
    }
  },
  data () {
    const show = this.show
    return {
      isShow: show,
      alive: true,
      styleText: {}
    }
  },
  mounted () {
    if (this.duration) {
      setTimeout(() => {
        this.close()
      }, this.duration)
    }
  },
  watch: {
    isShow (val) {
      /**
       * Stackable logic
       */
      if (val) {
        const x = document.getElementsByClassName(
          'va-notification-in'
        )
        this.numberOfParentModals = x.length
        // const distanceToMove = 5
        if (this.numberOfParentModals > 0) {
          for (let i = 0; i < this.numberOfParentModals; i++) {
            const currentMarginTop = x[i].style['top']
            if (currentMarginTop && currentMarginTop !== '0px') {
              // const m = Math.abs(currentMarginTop.slice(0, -2))
              // const dist = parseInt(m + distanceToMove)
              // x[i].style['margin-top'] = dist + 'px'
              // x[i].style['top'] = '-' + dist + 'px'
              // x[i].style['right'] = '-' + dist + 'px'
            } else {
              // var height = x[i].clientHeight + 25
              // x[i].style['transform'] = 'translateY(' + dialog + 'px)'
              // x[i].style['bottom'] = '-100px'
              // x[i].style['bottom'] = distanceToMove * -1 + 'px'
              // x[i].style['left'] = distanceToMove * -1 + 'px'
            }
          }
        }
      } else {
        const x = document.getElementsByClassName(
          'va-notification-in'
        )
        this.numberOfParentModals = x.length
        const distanceToMove = 5
        if (this.numberOfParentModals > 0) {
          for (let i = 0; i < this.numberOfParentModals; i++) {
            const currentMarginTop = x[i].style['top']
            if (currentMarginTop && currentMarginTop !== '0px') {
              const m = Math.abs(currentMarginTop.slice(0, -2))
              const dist = parseInt(m - distanceToMove)
              x[i].style['top'] = '-' + dist + 'px'
              x[i].style['right'] = '-' + dist + 'px'
            }
          }
        }
      }

      /**
       * Classes
       */
      const el = this.$el
      const body = document.body
      if (val) {
        this.$emit('show', { type: 'show' })
        el.querySelector('.' + 'va-notification')
        el.style.display = 'block'
        // timeout required for opacity transition
        setTimeout(() => {
          element.addClass(el, 'va-notification-in')
        }, 20)
        element.addClass(body, 'va-notification-open')
      } else {
        this.$emit('hide', { type: 'hide' })
        element.removeClass(el, 'va-notification-in')
        element.addClass(el, 'va-notification-out')
        setTimeout(() => {
          el.remove()
          element.removeClass(body, 'va-notification-open')
          element.removeClass(el, 'va-notification-out')
          this.$emit('closed', { type: 'closed' })
        }, 300)
      }
    }
  },
  methods: {
    getTranslateY (obj) {
      let match = obj.match(/translateY\(([0-9]+(px|em|%|ex|ch|rem|vh|vw|vmin|vmax|mm|cm|in|pt|pc))\)/)
      if (match != null) {
        return {
          0: match[1].split('px')[0],
          1: match[1].split('px')[0] + 'px'
        }
      }
    },
    close () {
      this.isShow = false
      setTimeout(() => {
        this.alive = false
      }, 500)
    },
    open () {
      this.isShow = true
    },
    confirm () {
      this.$emit('confirm', { type: 'confirm' })
    }
  },
  computed: {
    classObj () {
      const { effect, type } = this
      const classes = {}

      classes['va-notification'] = true
      classes['va-notification-' + type] = true
      classes['va-notification-' + effect] = true

      return classes
    },
    styleObj () {
      return {}
    },
    notificationIconType () {
      const { type } = this

      switch (type) {
        case 'default':
          return 'home'
        case 'warning':
          return 'exclamation-triangle'
        case 'danger':
          return 'exclamation-circle'
        case 'success':
          return 'check-circle'
        case 'info':
          return 'info-circle'
      }

      return 'info-circle'
    }
  }
}
</script>

<style lang="scss" src="../style/_reset.scss" scoped></style>
<style lang="scss">
@import "../variables";

.va-notification {
  position: fixed;
  left: 3rem;
  bottom: 1.5rem;
  z-index: 2000;
  display: none;
  overflow: auto;
  outline: 0;
  transition: transform 400ms ease-in-out 0s;

  &-icon {
    font-size: 1.7em;
  }

  &-dialog {
    position: relative;
    width: auto;
    margin: 0 25px 20px 25px;
  }

  &-content {
    position: relative;
    background-color: $N0;
    background-clip: padding-box;
    outline: 0;
    box-shadow: none;
    border: none;
  }

  /**
   * Expands to va-notification-fade va-notification-in
   */
  &-fade#{&}-in {
    opacity: 1 !important;
  }

  /**
   * fade-left
   */
  &-fade-left &-content {
    opacity: 0;
    transform: translateX(-100px);
    transition: transform 0.5s, opacity 0.5s;
  }

  &-fade-left#{&}-in &-content {
    opacity: 1;
    transform: translateX(0);
    -webkit-box-shadow: 0px 5px 5px -2px rgba(34, 60, 80, 0.25);
    -moz-box-shadow: 0px 5px 5px -2px rgba(34, 60, 80, 0.25);
    box-shadow: 0px 5px 5px -2px rgba(34, 60, 80, 0.25);
  }

  &-fade-left#{&}-out &-content {
    opacity: 0;
    transform: translateX(-100px);
    transition: transform 0.5s, opacity 0.5s;
  }

  /**
   * fade-right
   */
  &-fade-right &-content {
    opacity: 0;
    transform: translateX(20px);
    transition: transform 0.15s, opacity 0.15s;
  }

  &-fade-right#{&}-in &-content {
    opacity: 1;
    transform: translateX(0);
    box-shadow: rgba(9, 30, 66, 0.08) 0px 1px 2px 0px,
      rgba(9, 30, 66, 0.08) 0px 2px 4px, rgba(9, 30, 66, 0.31) 0px 3px 20px -5px;
  }

  &-fade-right#{&}-out &-content {
    opacity: 0;
    transform: translateX(20px);
  }

  @mixin notification-content-inner-mixin($type, $borderColor, $iconColor) {
    .va-notification-content-inner-#{$type} {
      display: flex;
      flex-direction: row;
      &-left {
        flex-basis: 40px;
        display: flex;
        flex-direction: column;
        justify-content: space-around;
        text-align: center;
        margin-left: 1em;
        i {
          color: $iconColor;
        }
      }
      &-right {
        flex: 1;
        padding: 20px 20px 20px 1em;
        &-close {
          position: absolute;
          top: 13px;
          right: 13px;
        }
        &-title {
          font-weight: bold;
          max-width: 90%;
        }
        &-message {
          margin-top: 5px;
        }
      }
    }
  }

  @mixin notification-content-mixin(
    $type,
    $background,
    $textColor
  ) {
    .va-notification-content {
      background: $background;
    }
    .va-notification-content-text {
      color: $textColor;
    }
    @include notification-content-inner-mixin($type, $background, '');
  }

  &-warning {
    @include notification-content-mixin('warning', $WARNING, $G252858);
  }

  &-danger {
    @include notification-content-mixin('danger', $DANGER, $WHITE);
  }

  &-success {
    @include notification-content-mixin('success', $SUCCESS, $WHITE);
  }

  &-info {
    @include notification-content-mixin('info', $INFO, $WHITE);
  }
}

.va-notification:first-child {
  animation: initial;
}

.va-notification:nth-child(n+1) {
  transform: translateX(0px) translateY(100%) translateY(1em);
}

.va-notification:last-child {
  transform: none;
}
</style>
