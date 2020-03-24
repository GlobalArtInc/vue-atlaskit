<template>
  <transition :name="(this.placement === 'left') ? 'slideleft' : 'slideright'">
    <div :class="classObj" style="padding: 10px" ref="iside" v-show="show">
      <div class="va-iside-dialog">
        <div class="va-iside-content">
          <div class="va-iside-header" v-if="header" >
            <va-button @click="close" style="float:left"><va-icon type="times"/></va-button>
            <div class="va-iside-title" v-if="title">{{title}}</div>
          </div>
          <div class="va-iside-body">
            <slot/>
          </div>
          <div class="va-iside-footer">
            <slot name="footer" />
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  name: 'VaIside',
  props: {
    placement: {
      type: String,
      default: 'left',
      required: false
    },
    title: {
      type: String,
      default: '',
      required: false
    },
    header: {
      type: Boolean,
      default: false,
      required: false
    },
    width: {
      type: String,
      default: '304px',
      required: false
    }
  },
  data () {
    return {
      show: false,
      focusTrap: null
    }
  },
  computed: {
    classObj () {
      const { placement } = this
      const classes = {}

      classes['va-iside'] = true
      classes['va-iside-left'] = placement === 'left'
      classes['va-iside-right'] = placement === 'right'

      return classes
    }
  },
  methods: {
    open () {
      this.show = true
    },
    close () {
      this.show = false
    }
  }
}
</script>

<style lang="scss" src="../style/_reset.scss" scoped></style>
<style lang="scss">
  @import "../variables";

  .va-iside-open {
    transition: transform 0.15s;
  }

  @media only screen and (max-width: 757px) {
    .va-iside {
      width: 100%
    }
  }
  @media only screen and (min-width: 758px) {
    .va-iside {
      width: 30%
    }
  }

  .va-iside-body {
    padding-top: 10px;
  }

  .va-iside-footer {
    position:absolute;
    bottom:10px;
  }

  .va-iside {
    position: fixed;
    top: 0;
    bottom: 0;
    margin: 0;
    z-index: 10;
    overflow: auto;
    background: $N0;
    &-left {
      left: 0;
      right: auto;
    }
    &-right {
      right: 0;
      left: auto;
    }
    &:focus {
      outline: 0;
    }
    &-dialog {
      .va-iside-header {
        .va-close {
          font-size: 24px;
          color: $N300;
        }
        .va-iside-title {
          padding-top: 8px;
          font-size: 24px;
          color: $N300;
        }
      }
    }
    &-backdrop {
      position: fixed;
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
      z-index: 5;
      opacity: 0;
      transition: opacity 0.15s ease-in-out;
      background: rgba(9, 30, 66, 0.54);
    }
    &-in {
      opacity: 1;
    }
  }
</style>
