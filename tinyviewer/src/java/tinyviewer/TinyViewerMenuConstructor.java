package tinyviewer;

import crossbase.ui.HotKey;
import crossbase.ui.MenuConstructorBase;
import crossbase.ui.actions.Action;
import crossbase.ui.actions.Handler;

public class TinyViewerMenuConstructor extends MenuConstructorBase<ImageViewWindow>
{
	private Handler<ImageViewWindow> fileOpenHandler;
	private Action<ImageViewWindow> openAction;
	
	public TinyViewerMenuConstructor() {
		super();
		
		openAction = new Action<>("&Open");
		openAction.setHotKey(new HotKey(HotKey.MOD1, 'O'));
		getFileActionCategory().addFirstItem(openAction);
	}
	
	public Handler<ImageViewWindow> getFileOpenHandler()
	{
		return fileOpenHandler;
	}

	public void setFileOpenHandler(Handler<ImageViewWindow> fileOpenHandler)
	{
		this.fileOpenHandler = fileOpenHandler;
		if (openAction.getHandlers().get(null) == null) {

			openAction.getHandlers().put(null, fileOpenHandler);
		}
	}

}
