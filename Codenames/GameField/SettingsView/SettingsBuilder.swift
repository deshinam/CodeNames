
import UIKit

class SettingsBuilder {
   
    private var view: SettingsView?
    private var viewModel: SettingsViewModel?

    func build(gameManager: GameManager) -> SettingsView {
        viewModel = SettingsViewModel(gameManager: gameManager)
        view = SettingsView(settingsViewModel: viewModel!)
        return view!
    }
    
    func dismissAction(closure: @escaping ()->()) {
        viewModel?.dismissAction = closure
    }

}
