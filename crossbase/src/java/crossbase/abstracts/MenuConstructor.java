package crossbase.abstracts;

import org.eclipse.swt.events.SelectionAdapter;

import crossbase.abstracts.ViewWindow;
import crossbase.ui.actions.ActionCategory;

public interface MenuConstructor<TD extends Document, TVW extends ViewWindow<TD>>
{
	void setExitSelectionAdapter(SelectionAdapter exitSelectionAdapter);
	void setAboutSelectionAdapter(SelectionAdapter aboutSelectionAdapter);

	public ActionCategory<TD, TVW> getActionsRoot();
	/**
	 * This function should update menus for the specified window. 
	 * If no window is specified, it should update the global menu 
	 * (this feature is OS X only) 
	 * @param window the window to update the menu for
	 */
	void updateMenus(TVW window);
}
