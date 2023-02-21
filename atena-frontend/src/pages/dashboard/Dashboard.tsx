import { PageBaseLayout } from '../../shared/layouts';
import { ToolBar } from '../toolbar/ToolBar';


export const DashBoard: React.FC = () => {
    return (
        <PageBaseLayout 
            title='Dashboard' 
            toolBar={(
                <ToolBar 
                    activeSearch
                />
            )}
        >
            Conteudo
        </PageBaseLayout>
    );
};