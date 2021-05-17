export const multilingual = {
  namespaced: true,
  state: {
    selectedLanguage: {}
  },
  actions: {
    changeLang({ commit }, option) {
      commit('changeLang', option);
    }
  },
  mutations: {
    changeLang(state, option) {
      state.selectedLanguage = option;
    }
  }
}