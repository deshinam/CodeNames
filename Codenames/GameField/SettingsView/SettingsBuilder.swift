
import UIKit

final class SettingsBuilder {
    // MARK: — Private Properties
    private var view: SettingsView?
    private var viewModel: SettingsViewModel?

    // MARK: — Public Methods
    func build(gameManager: GameManager) -> SettingsView {
        viewModel = SettingsViewModel(gameManager: gameManager)
        view = SettingsView(settingsViewModel: viewModel!)
        return view!
    }
    
    func dismissAction(closure: @escaping ()->()) {
        viewModel?.dismissAction = closure
    }
}
