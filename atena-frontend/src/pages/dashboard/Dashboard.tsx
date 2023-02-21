import { PageBaseLayout } from '../../shared/layouts';
import { ToolBarList } from '../toolbar-list/ToolBarList';


export const DashBoard: React.FC = () => {
    return (
        <PageBaseLayout
            title='Dashboard'
            toolBar={(
                <ToolBarList
                    activeSearch
                />
            )}
        >
            Conteudo
        </PageBaseLayout>
    );
};