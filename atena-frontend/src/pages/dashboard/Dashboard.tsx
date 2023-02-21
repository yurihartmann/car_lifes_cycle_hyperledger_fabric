import { ToolBarDetails } from '../../shared/components';
import { PageBaseLayout } from '../../shared/layouts';


export const DashBoard: React.FC = () => {
    return (
        <PageBaseLayout
            title='Dashboard'
            toolBar={(
                <ToolBarDetails />
            )}
        >
            Conteudo
        </PageBaseLayout>
    );
};